using Tk
using Images
using ImageView

iterations = 90
imgsize = 1000

mandelbrot(z, c) = z.^2 + c

img = [ Color.HSV(0, 0, 0) for x=1:imgsize, y=1:imgsize ]
c = [
    x + y*im
        for x=linspace(-2.0, 2.0, imgsize), y=linspace(-2.0, 2.0, imgsize)
]
z = c

imgc, imgslice = view(img)

for i = 1:iterations
  z = mandelbrot(z, c)
  img[abs(z) .> 50] = Color.HSV(i * 360/iterations, 1, 1)
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
