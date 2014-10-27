using Tk
using ImageView
using Color

using FractalExplorer

iterations = 45
imgsize = (640, 480)

win = Toplevel("FractalExplorer", imgsize[1], imgsize[2], false)
frame = Frame(win)
pack(frame, expand=true, fill="both")
canvas = Canvas(frame, imgsize[1], imgsize[2])
pack(canvas, expand=true, fill="both")
set_visible(win, true)
view(canvas, [ 0.0 for y=1:imgsize[2], x=1:imgsize[1] ], interactive=false)

mandelbrot(canvas, iterations)
