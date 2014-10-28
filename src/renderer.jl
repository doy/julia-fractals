using Tk
using Images
using ImageView
using Color

type FractalCanvas
    c::Canvas
    f::FractalExplorer.Fractal
    image::Array{HSV{Float64}, 2}

    function FractalCanvas(c::Canvas, bb::Base.Graphics.BoundingBox, make_c::Function, step::Function)
        winsize = tuple(get_size(c)...)
        f = FractalExplorer.Fractal{Float64}(winsize, bb, make_c, step)
        image = [ HSV(0, 0, 0) for y=1:winsize[2], x=1:winsize[1] ]
        fc = new(c, f, image)
        c.draw = function(x)
            props = Dict()
            img2 = ImageView.ImageSlice2d(fc.image, props)
            imgc = ImageView.ImageCanvas(ImageView.cairo_format(fc.image), props)
            imgc.c = fc.c
            ImageView.allocate_surface!(imgc, winsize[1], winsize[2])
            ImageView.rerender(imgc, img2)
            ImageView.resize(imgc, img2)
        end
        bind(c, "<Double-Button-1>", (path,x,y)->fractal(c, make_c, step, false))
        c.mouse.button1press = function(c, x, y)
            function rubberband_end(c, bb)
                (size_x, size_y) = tuple(get_size(c)...)
                win_aspect_ratio = size_x / size_y
                box_aspect_ratio = (bb.xmax - bb.xmin) / (bb.ymax - bb.ymin)
                line_x = linspace(fc.f.bb.xmin, fc.f.bb.xmax, size_x)
                line_y = linspace(fc.f.bb.ymin, fc.f.bb.ymax, size_y)
                plane = [ (x, y) for x=line_x, y=line_y ]
                if box_aspect_ratio > win_aspect_ratio
                    xmin = plane[bb.xmin, bb.ymin][1]
                    xmax = plane[bb.xmax, bb.ymax][1]
                    ymin = plane[bb.xmin, bb.ymin][2]
                    ymax = ymin + (xmax - xmin)
                else
                    xmin = plane[bb.xmin, bb.ymin][1]
                    ymin = plane[bb.xmin, bb.ymin][2]
                    ymax = plane[bb.xmax, bb.ymax][2]
                    xmax = xmin + (ymax - ymin)
                end
                bb = Base.Graphics.BoundingBox(xmin, xmax, ymin, ymax)
                fractal(c, make_c, step, false, bb)
            end
            ImageView.rubberband_start(c, x, y, rubberband_end)
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
function fractal(canvas::Canvas, make_c::Function, step::Function, should_wait=!isinteractive(), bb=Base.Graphics.BoundingBox(-2.0, 2.0, -2.0, 2.0))
    fc = FractalCanvas(canvas, bb, make_c, step)

    saw_some_pixels = false
    for i in 1:1000
        FractalExplorer.step(fc.f)
        diverging_pixels = (abs(fc.f.z) .> 2)
        new_pixels = diverging_pixels & (fc.image .== HSV(0, 0, 0))
        fc.image[new_pixels] = HSV(i * 4, 1, 1)
        redraw(fc)
        if saw_some_pixels && length(find(new_pixels)) <= 1
            break
        end
        if length(find(diverging_pixels)) > 0
            saw_some_pixels = true
        end
    end

    if should_wait
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
