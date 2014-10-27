using Tk
using Images
using ImageView
using Color

function renderfractal(imgc, iterations, make_c, step)
    imgsize = get_size(canvas(imgc))
    img = [ HSV(0, 0, 0) for y=1:imgsize[1], x=1:imgsize[2] ]
    f = FractalExplorer.Fractal{Float64}(imgsize, make_c, step)

    for i = 1:iterations
        FractalExplorer.step(f)
        new_pixels = (abs(f.z) .> 2) & (img .== HSV(0, 0, 0))
        img[new_pixels] = HSV(i * 360/iterations, 1, 1)
        view(imgc, img)
    end

    if (!isinteractive())
        cv = Condition()
        win = toplevel(imgc)
        bind(win, "<Destroy>", e->notify(cv))
        wait(cv)
    end
end

function mandelbrot(imgc, iterations = 45)
    renderfractal(imgc, iterations, z -> z, (z, c) -> z.^2 + c)
end

function julia(imgc, iterations = 45, c = 0)
    renderfractal(imgc, iterations, z -> c, (z, c) -> z.^2 + c)
end
