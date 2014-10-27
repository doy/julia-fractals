using Tk
using Images
using ImageView
using Color

type FractalCanvas
    c::Canvas
    f::FractalExplorer.Fractal
    image::Array{HSV{Float64}, 2}

    function FractalCanvas(c::Canvas, make_c::Function, step::Function)
        winsize = tuple(get_size(c)...)
        f = FractalExplorer.Fractal{Float64}(winsize, make_c, step)
        image = [ HSV(0, 0, 0) for y=1:winsize[1], x=1:winsize[2] ]
        fc = new(c, f, image)
        redraw(fc)
        c.draw = function(x)
            props = Dict()
            img2 = ImageView.ImageSlice2d(fc.image, props)
            imgc = ImageView.ImageCanvas(ImageView.cairo_format(fc.image), props)
            imgc.c = fc.c
            ImageView.allocate_surface!(imgc, winsize[2], winsize[1])
            ImageView.rerender(imgc, img2)
            ImageView.resize(imgc, img2)
        end
        return fc
    end
end

mandelbrot(fc::FractalCanvas) = mandelbrot(fc.c)
function mandelbrot(canvas::Canvas = createwindow())
    return fractal(canvas, z -> z, (z, c) -> z.^2 + c)
end

julia(fc::FractalCanvas, c = 0) = julia(fc.c, c)
function julia(canvas::Canvas = createwindow(), c::Union(Number, Array{Number, 2}) = 0)
    return fractal(canvas, z -> c, (z, c) -> z.^2 + c)
end

fractal(make_c, step) = fractal(createwindow(), make_c, step)
fractal(fc::FractalCanvas, make_c, step) = fractal(fc.c, make_c, step)
function fractal(canvas::Canvas, make_c::Function, step::Function)
    fc = FractalCanvas(canvas, make_c, step)

    i = 0
    while true
        FractalExplorer.step(fc.f)
        new_pixels = (abs(fc.f.z) .> 2) & (fc.image .== HSV(0, 0, 0))
        fc.image[new_pixels] = HSV(i * 4, 1, 1)
        i = i + 1
        redraw(fc)
        if length(find(new_pixels)) <= 1
            break
        end
    end

    if (!isinteractive())
        cv = Condition()
        win = Tk.toplevel(fc.c)
        bind(win, "<Destroy>", e->notify(cv))
        wait(cv)
    end

    return fc
end

function createwindow(winsize::(Integer, Integer) = (640, 480))
    win = Toplevel("FractalExplorer", winsize[1], winsize[2], false)
    frame = Frame(win)
    pack(frame, expand=true, fill="both")
    canvas = Canvas(frame, winsize[1], winsize[2])
    pack(canvas, expand=true, fill="both")
    set_visible(win, true)
    # XXX this is needed because not calling view before get_size causes things
    # to fail for some reason? it shouldn't be necessary otherwise
    view(canvas, [ HSV(0, 0, 0) for y=1:winsize[2], x=1:winsize[1] ], interactive=false)
    return canvas
end

function redraw(fc::FractalCanvas)
    return view(fc.c, fc.image, interactive=false)
end
