import numpy as np


def get_im_local_window_ind_rf(xy, imsz, wndra, skipstep):
    ccx = np.where(
        np.logical_and(xy[:, 0] < imsz[1] - wndra - 1, xy[:, 0] > wndra + 1)
    )[0]
    ccy = np.where(
        np.logical_and(xy[:, 1] < imsz[0] - wndra - 1, xy[:, 1] > wndra + 1)
    )[0]

    print(ccy)
    cc = np.intersect1d(ccx, ccy)

    xmin = xy[:, 0] - wndra
    ymin = xy[:, 1] - wndra

    indmin = np.ravel_multi_index((ymin, xmin), imsz, order="F") + 1

    gx, gy = np.meshgrid(
        np.arange(0, 2 * wndra + 1, skipstep) * imsz[1],
        np.arange(0, 2 * wndra + 1, skipstep),
    )
    gxy = gx + gy
    gxy = gxy.flatten()

    ind = indmin + gxy

    print(ind, cc)

    return ind[cc], cc


# Example usage
xy = np.array([[50, 50]])  # Example centroid
imsz = (100, 100)  # Example image size
wndra = 5
skipstep = 1

ind, cc = get_im_local_window_ind_rf(xy, imsz, wndra, skipstep)
print(ind)
