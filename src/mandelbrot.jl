type Mandelbrot{T <: FloatingPoint}
    c::Array{Complex{T}, 2}
    z::Array{Complex{T}, 2}

    Mandelbrot(imgsize) = (
        line = linspace(-2.0, 2.0, imgsize);
        plane = [ x + y*im for x=line, y=line ];
        new(plane, plane)
    )
end

function step{T <: FloatingPoint}(m::Mandelbrot{T})
    m.z = m.z.^2 + m.c
end
