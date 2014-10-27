type Fractal{T <: FloatingPoint}
    z::Array{Complex{T}, 2}
    c::Array{Complex{T}, 2}
    step::Function

    function Fractal(
        imgsize::(Integer, Integer),
        make_c::Function,
        step::Function
    )
        (size_y, size_x) = imgsize
        aspect_ratio = size_y / size_x
        if size_x < size_y
            range_x = (-2.0 * aspect_ratio, 2.0 * aspect_ratio)
            range_y = (-2.0, 2.0)
        else
            range_x = (-2.0, 2.0)
            range_y = (-2.0 / aspect_ratio, 2.0 / aspect_ratio)
        end
        line_x = linspace(range_x[1], range_x[2], size_x)
        line_y = linspace(range_y[1], range_y[2], size_y)
        plane = [ complex(x, y) for y=line_y, x=line_x ]
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
