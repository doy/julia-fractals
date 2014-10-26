using Tk
using Images
using ImageView

using FractalExplorer

iterations = 45
imgsize = (640, 480)

img = [ Color.HSV(0, 0, 0) for x=1:imgsize[1], y=1:imgsize[2] ]
mandelbrot = FractalExplorer.Fractal{Float64}(imgsize)

imgc, imgslice = view(img)

for i = 1:iterations
  FractalExplorer.step(mandelbrot)
  new_pixels = (abs(mandelbrot.z) .> 2) & (img .== Color.HSV(0, 0, 0))
  img[new_pixels] = Color.HSV(i * 360/iterations, 1, 1)
  view(imgc, img)
end

#If we are not in a REPL
if (!isinteractive())

    # Create a condition object
    cv = Condition()

    # Get the main window (A Tk toplevel object)
    win = toplevel(imgc)

    # Notify the condition object when the window closes
    bind(win, "<Destroy>", e->notify(cv))

    # Wait for the notification before proceeding ... 
    wait(cv)
end
