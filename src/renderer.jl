using Tk
using Images
using ImageView
using Color

function render(imgc, iterations = 45, make_c = z -> z, step = (z, c) -> z.^2 + c)
    imgsize = get_size(canvas(imgc))
    img = [ HSV(0, 0, 0) for y=1:imgsize[1], x=1:imgsize[2] ]
    f = FractalExplorer.Fractal{Float64}(imgsize, make_c, step)

    for i = 1:iterations
        FractalExplorer.step(f)
        new_pixels = (abs(f.z) .> 2) & (img .== HSV(0, 0, 0))
        img[new_pixels] = HSV(i * 360/iterations, 1, 1)
        view(imgc, img)
    end
end
