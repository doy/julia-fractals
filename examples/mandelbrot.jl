using Tk
using Images
using ImageView

using Fractal

iterations = 45
imgsize = 500

img = [ Color.HSV(0, 0, 0) for x=1:imgsize, y=1:imgsize ]
m = Fractal.Mandelbrot{Float64}(imgsize)

imgc, imgslice = view(img)

for i = 1:iterations
  Fractal.step(m)
  new_pixels = (abs(m.z) .> 2) & (img .== Color.HSV(0, 0, 0))
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
