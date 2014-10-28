type Fractal{T <: FloatingPoint}
    z::Array{Complex{T}, 2}
    c::Array{Complex{T}, 2}
    step::Function
    bb::Base.Graphics.BoundingBox

    function Fractal(
        imgsize::(Integer, Integer),
        bb::Base.Graphics.BoundingBox,
        make_c::Function,
        step::Function
    )
        (size_x, size_y) = imgsize
        aspect_ratio = size_y / size_x
        if size_x < size_y
            scaled_bb = Base.Graphics.BoundingBox(
                bb.xmin, bb.xmax,
                bb.ymin, bb.ymin + (bb.ymax - bb.ymin) * aspect_ratio
            )
        else
            scaled_bb = Base.Graphics.BoundingBox(
                bb.xmin, bb.xmin + (bb.xmax - bb.xmin) / aspect_ratio,
                bb.ymin, bb.ymax,
            )
        end
        line_x = linspace(scaled_bb.xmin, scaled_bb.xmax, size_x)
        line_y = linspace(scaled_bb.ymin, scaled_bb.ymax, size_y)
        plane = [ complex(x, y) for y=line_y, x=line_x ]
        c = make_c(plane)
        if !isa(c, Array)
            c = ones(plane) .* c
        end
        new(plane, c, step, scaled_bb)
    end
end

function step{T <: FloatingPoint}(f::Fractal{T})
    f.z = f.step(f.z, f.c)
end
