using Tk
using ImageView
using Color

using FractalExplorer

iterations = 45
imgsize = (640, 480)

imgc, imgslice = view([ HSV(0, 0, 0) for y=1:imgsize[2], x=1:imgsize[1] ])
mandelbrot(imgc, iterations)
