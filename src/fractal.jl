type Fractal{T <: FloatingPoint}
    z::Array{Complex{T}, 2}
    c::Array{Complex{T}, 2}
    step::Function

    function Fractal(imgsize, make_c = z -> z, step = (z, c) -> z.^2 + c)
        line = linspace(-2.0, 2.0, imgsize)
        plane = [ complex(x, y) for x=line, y=line ]
        new(plane, make_c(plane), step)
    end
end

function step{T <: FloatingPoint}(f::Fractal{T})
    f.z = f.step(f.z, f.c)
end
