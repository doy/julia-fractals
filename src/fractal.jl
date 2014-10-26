type Fractal{T <: FloatingPoint}
    z::Array{Complex{T}, 2}
    c::Array{Complex{T}, 2}
    step::Function

    function Fractal(imgsize, make_c = z -> z, step = (z, c) -> z.^2 + c)
        line = linspace(-2.0, 2.0, imgsize)
        plane = [ complex(x, y) for x=line, y=line ]
        c = make_c(plane)
        if !isa(c, Array)
            c = ones(plane) .* c
        end
        new(plane, c, step)
    end
end

function step{T <: FloatingPoint}(f::Fractal{T})
    f.z = f.step(f.z, f.c)
end
