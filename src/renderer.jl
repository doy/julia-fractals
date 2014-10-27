using Tk
using Images
using ImageView
using Color

function fractal(canvas, make_c, step)
    imgsize = get_size(canvas)
    img = [ HSV(0, 0, 0) for y=1:imgsize[1], x=1:imgsize[2] ]
    view(canvas, img, interactive=false)

    f = FractalExplorer.Fractal{Float64}(imgsize, make_c, step)

    i = 0
    while true
        FractalExplorer.step(f)
        new_pixels = (abs(f.z) .> 2) & (img .== HSV(0, 0, 0))
        img[new_pixels] = HSV(i * 4, 1, 1)
        i = i + 1
        view(canvas, img, interactive=false)
        if length(find(new_pixels)) <= 1
            break
        end
    end

    if (!isinteractive())
        cv = Condition()
        win = Tk.toplevel(canvas)
        bind(win, "<Destroy>", e->notify(cv))
        wait(cv)
    end
end

function mandelbrot(canvas)
    fractal(canvas, z -> z, (z, c) -> z.^2 + c)
end

function julia(canvas, c = 0)
    fractal(canvas, z -> c, (z, c) -> z.^2 + c)
end
