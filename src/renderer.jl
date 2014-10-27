using Tk
using Images
using ImageView
using Color

mandelbrot() = mandelbrot(createwindow())
function mandelbrot(canvas::Canvas)
    fractal(canvas, z -> z, (z, c) -> z.^2 + c)
end

julia(c = 0) = julia(createwindow(), c)
function julia(canvas::Canvas, c::Union(Number, Array{Number, 2}) = 0)
    fractal(canvas, z -> c, (z, c) -> z.^2 + c)
end

fractal(make_c, step) = fractal(createwindow(), make_c, step)
function fractal(canvas::Canvas, make_c::Function, step::Function)
    imgsize = tuple(get_size(canvas)...)
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

function createwindow(winsize::(Integer, Integer) = (640, 480))
    win = Toplevel("FractalExplorer", winsize[1], winsize[2], false)
    frame = Frame(win)
    pack(frame, expand=true, fill="both")
    canvas = Canvas(frame, winsize[1], winsize[2])
    pack(canvas, expand=true, fill="both")
    set_visible(win, true)
    view(canvas, [ 0.0 for y=1:winsize[2], x=1:winsize[1] ], interactive=false)
    return canvas
end
