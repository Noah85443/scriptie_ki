const fs = require("fs");
const { create } = require("xmlbuilder2");

let geoJson = {
  features: [
    {
      geometry: {
        type: "Polygon",
        coordinates: [
          [
            [1, 2],
            [1, 2],
            [1, 2],
            [1, 2],
            [1, 2],
            [1, 2],
          ],
        ],
      },
    },
  ],
};
geoJson = JSON.parse(
  fs.readFileSync("deeplearning/H21-066.4_HE332_285_Scan1#1-1.geojson", {
    encoding: "utf8",
    flag: "r",
  })
);

const root = create({ version: "1.0" })
  .ele("Annotations", { MicronsPerPixel: "0.250000" })
  .ele("Annotation", {
    Id: "1",
    Name: "BALT hyperplasia",
    ReadOnly: "0" /* ... etc */,
  })
  .ele("Attributes")
  .ele("Attribute", { Name: "Description", Id: "0", Value: "" })
  .up()
  .up()
  .ele("Regions")
  .ele("RegionAttributeHeaders")
  .ele("AttributeHeader", { Id: "9999" })
  .up()
  .ele("AttributeHeader", { Id: "9999" })
  .up()
  .ele("AttributeHeader", { Id: "9999" })
  .up()
  .up();

// loop through regions (these are the different objects {} in features array)
geoJson.features.map((feature) => {
  let w = root
    .ele("Region", { Id: "123" })
    .ele("Attributes")
    .up()
    .ele("Vertices");

  // loop through vertices (these are the coordinates in the feature variable now)
  // the coordinates are a nested array??? stupid haha
  console.log(feature.geometry.coordinates[0]);
  feature.geometry.coordinates[0].map((c) => {
    w.ele("Vertex", { X: c[0] / 8, Y: c[1] / 8 });
  });
});
root.up().ele("Plots");

// convert the XML tree to string
const xml = root.end({ prettyPrint: true });
console.log(xml);

// write to file
fs.writeFileSync("deeplearning/H21-066.4_HE332_285_Scan1.xml", xml);
