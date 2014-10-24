function complexplane(range, divisions)
    line = linspace(-range / 2.0, range / 2.0, divisions)
    [ x + y*im for x=line, y=line ]
end
