type Fractal{T <: FloatingPoint}
    z::Array{Complex{T}, 2}
    c::Array{Complex{T}, 2}
    step::Function

    function Fractal(
        imgsize::(Integer, Integer),
        range::(T, T, T, T),
        make_c::Function,
        step::Function
    )
        (ul_x, ul_y, width, height) = range
        (size_x, size_y) = imgsize
        aspect_ratio = size_y / size_x
        if size_x < size_y
            range_x = (ul_x, ul_x + width)
            range_y = (ul_y, ul_y + height * aspect_ratio)
        else
            range_x = (ul_x, ul_x + width / aspect_ratio)
            range_y = (ul_y, ul_y + height)
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
