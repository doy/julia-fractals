type Fractal{T <: FloatingPoint}
    z::Array{Complex{T}, 2}
    c::Array{Complex{T}, 2}
    step::Function

    function Fractal(imgsize, make_c = z -> z, step = (z, c) -> z.^2 + c)
        aspect_ratio = imgsize[2] / imgsize[1]
        if imgsize[1] < imgsize[2]
            range_x = (-2.0, 2.0)
            range_y = (-2.0 * aspect_ratio, 2.0 * aspect_ratio)
        else
            range_x = (-2.0 / aspect_ratio, 2.0 / aspect_ratio)
            range_y = (-2.0, 2.0)
        end
        line_x = linspace(range_x[1], range_x[2], imgsize[1])
        line_y = linspace(range_y[1], range_y[2], imgsize[2])
        plane = [ complex(x, y) for x=line_x, y=line_y ]
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
