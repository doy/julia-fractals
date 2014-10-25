type Mandelbrot
    c::Array{Complex{Float64}, 2}
    z::Array{Complex{Float64}, 2}

    Mandelbrot(imgsize) = (
        line = linspace(-2.0, 2.0, imgsize);
        plane = [ x + y*im for x=line, y=line ];
        new(plane, plane)
    )
end

function step(m::Mandelbrot)
    m.z = m.z.^2 + m.c
end
