function wait_user_input()

stable = false;
while ~stable
    in = input('Proceed?(y/n) ', 's');
    if in == 'y'
        stable = true;
    elseif in == 'n'
        error('program closed by user');
    end
end

end