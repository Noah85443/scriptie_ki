import numpy as np
from tifffile import TiffFile, TiffWriter
import argparse
from tqdm import tqdm


# Input all data from file
def tiff_in(args):
    with TiffFile(args.inputFile) as tif:
        # images = tif.asarray()
        pages = []
        for page in tif.pages:
            tags = {}
            for tag in page.tags.values():
                tags[tag.name] = tag.value
            pages.append([page.asarray(), tags])
        shapes = []
        for series in tif.series:
            shapes.append(series.shape)
    return pages, shapes


# Collect pages of a color band
def collect_band_pages(all_pages, shapes, band, bands):
    page = 0
    pages = []
    for shape in shapes:
        if shape[0] == bands:
            pages.append(all_pages[page + band])
            page += bands
        else:
            page += 1
    return pages


# For using in color-mapped TIFF format
def build_map(pages, color):
    r = np.linspace(0, 1, 256)
    map = (np.rint(np.array([r, r, r]).transpose() * color).astype("uint8")).transpose()
    return map


# Determine the color which a band is to have
def get_color(pages):
    # Set a default color
    default_color = [255, 255, 255]

    # Check if the key exists in the first page's tags
    if 0 < len(pages) and "image_description" in pages[0][1]:
        desc = pages[0][1]["image_description"]
        w = str(desc).partition("<Color>")[2].partition("</Color>")[0].split(",")
        color = [int(w[0]), int(w[1]), int(w[2])]
    else:
        # Use the default color if the key is not present
        color = default_color

    return color


# Convert greyscale values to RGB
def convert2rgb(page, color):
    pageRGB = np.zeros((page[0].shape[0], page[0].shape[1], 3), dtype="uint8")
    for i in range(3):
        if color[i] == 255:
            pageRGB[:, :, i] = page[0]
        elif color[i] != 0:
            pageRGB[:, :, i] = (page[0] * (color[i] / 255)).astype("uint8")
    return pageRGB


def tiff_out(args, name, pages, color):
    with TiffWriter(name, bigtiff=True) as tif:
        # 		for page in pages:
        if args.mode == "map":
            map = build_map(pages, color)
            for page in tqdm(pages[0 : args.levels]):
                if "tile_length" in page[1].keys():
                    tif.write(
                        page[0],
                        tile=(page[1]["tile_length"], page[1]["tile_length"]),
                        colormap=map,
                        compression="zlib",
                        # if args.compression == 10
                        # else args.compression,
                        # # 						 description=page[1]['image_description'],
                        resolution=(page[1]["XResolution"], page[1]["YResolution"]),
                    )
                else:
                    tif.write(
                        page[0],
                        # 						 tile=(256,256),
                        colormap=map,
                        compression="zlib",
                        # if args.compression == 10
                        # else args.compression,
                        # # 						 description=page[1]['image_description'],
                        resolution=(page[1]["XResolution"], page[1]["YResolution"]),
                    )
        else:
            for page in tqdm(pages[0 : args.levels]):
                pageRGB = convert2rgb(page, color)
                if "tile_length" in page[1].keys():
                    tif.write(
                        pageRGB,
                        tile=(page[1]["tile_length"], page[1]["tile_length"]),
                        compression="zlib",
                        # if args.compression == 10
                        # else args.compression,
                        # # 						 description=page[1]['image_description'],
                        resolution=(page[1]["XResolution"], page[1]["YResolution"]),
                    )
                else:
                    tif.write(
                        pageRGB,
                        # 						 tile=(256,256),
                        compression="zlib",
                        # if args.compression == 10
                        # else args.compression,
                        # # 						 description=page[1]['image_description'],
                        resolution=(page[1]["XResolution"], page[1]["YResolution"]),
                    )


def tiff_ancillary(name, page):
    with TiffWriter(name, bigtiff=False) as tif:
        tif.save(page[0])


if __name__ == "__main__":
    args = []

    parser = argparse.ArgumentParser(
        description="Convert qptiff file to separate tiff files"
    )
    parser.add_argument(
        "-v", "--verbosity", action="count", default=0, help="increase output verbosity"
    )
    parser.add_argument(
        "-i", "--inputFile", type=str, help="qptiff file name", default="./scan.qptiff"
    )
    parser.add_argument("-o", "--outputFile", type=str, help="Output tiff base name")
    parser.add_argument(
        "-m",
        "--mode",
        choices=["map", "rgb"],
        help="Mapped or rgb color",
        default="map",
    )
    parser.add_argument(
        "-b",
        "--bands",
        type=int,
        help="Number of bands (colors) to process. O means all",
        default=0,
    )
    parser.add_argument(
        "-l",
        "--levels",
        type=int,
        help="Number of resolution levels to process. ) means all",
        default=0,
    )
    parser.add_argument(
        "-c",
        "--compression",
        type=int,
        help="Compression: None:0, zlib:1-9, LZMA:10",
        default=0,
    )

    args = parser.parse_args()
    if args.outputFile is None:
        args.outputFile = args.inputFile.partition(".qptiff")[0]
    (all_pages, shapes) = tiff_in(args)

    bands = shapes[0][0]

    for band in range(args.bands if args.bands else bands):
        pages = collect_band_pages(all_pages, shapes, band, bands)
        color = get_color(pages)
        args.levels = args.levels if args.levels else len(pages)
        tiff_out(
            args,
            args.outputFile
            + "."
            + args.mode
            + ".b"
            + str(band)
            + ".l"
            + str(args.levels)
            + ".c"
            + str(args.compression)
            + ".tif",
            pages,
            color,
        )

    tiff_ancillary(args.outputFile + ".thumb.tif", all_pages[bands])
    tiff_ancillary(args.outputFile + ".slide.tif", all_pages[-2])
    tiff_ancillary(args.outputFile + ".label.tif", all_pages[-1])

# import matplotlib.pyplot as plt
# import imageio.v2 as imageio
# from tifffile import imwrite
# import argparse


# def qptiff_to_tiff(input_file, output_file):
#     image = imageio.imread(input_file)
#     plt.imshow(image)
#     plt.show()

#     imwrite(output_file, image, compression=6)  # Adjust compression level as needed
#     print("done")


# if __name__ == "__main__":
#     parser = argparse.ArgumentParser(description="Convert QPTIFF file to TIFF")
#     parser.add_argument(
#         "-i", "--input_file", type=str, help="QPTIFF file name", required=True
#     )
#     parser.add_argument(
#         "-o", "--output_file", type=str, help="Output TIFF file name", required=True
#     )

#     args = parser.parse_args()

#     qptiff_to_tiff(args.input_file, args.output_file)
