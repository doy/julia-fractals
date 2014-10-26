using Tk
using ImageView
using Color

using FractalExplorer

iterations = 45
imgsize = (640, 480)

imgc, imgslice = view([ HSV(0, 0, 0) for y=1:imgsize[2], x=1:imgsize[1] ])
mandelbrot(imgc, iterations)

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
