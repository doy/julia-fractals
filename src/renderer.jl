using Tk
using Images
using ImageView
using Color

function renderfractal(canvas, iterations, make_c, step)
    imgsize = get_size(canvas)
    img = [ HSV(0, 0, 0) for y=1:imgsize[1], x=1:imgsize[2] ]
    view(canvas, img, interactive=false)

    f = FractalExplorer.Fractal{Float64}(imgsize, make_c, step)

    for i = 1:iterations
        FractalExplorer.step(f)
        new_pixels = (abs(f.z) .> 2) & (img .== HSV(0, 0, 0))
        img[new_pixels] = HSV(i * 360/iterations, 1, 1)
        view(canvas, img, interactive=false)
    end

    if (!isinteractive())
        cv = Condition()
        win = Tk.toplevel(canvas)
        bind(win, "<Destroy>", e->notify(cv))
        wait(cv)
    end
end

function mandelbrot(canvas, iterations = 45)
    renderfractal(canvas, iterations, z -> z, (z, c) -> z.^2 + c)
end

function julia(canvas, iterations = 45, c = 0)
    renderfractal(canvas, iterations, z -> c, (z, c) -> z.^2 + c)
end
