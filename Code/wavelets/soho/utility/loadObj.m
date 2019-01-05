function mesh = loadObj(filestr)

file = fopen(filestr);

mesh.V = zeros(4, 10000);
mesh.F = zeros(3, 200000);

v = [0;0;0;1];
f = [0;0;0];
i = 0;
numfaces = 0;
numverts = 0;

while ~feof(file)
    i = i + 1;
    if mod(i, 1000) == 0
        fprintf(1, '%d lines read\n', i)
    end   
    line = strtrim(fgetl(file));
    [token,line] = strtok(line);
    
    if strcmp(token, 'v')
        numverts = numverts + 1;
        k = 0;
        while k < 3 && ~isempty(line)
            k = k + 1;
            [token,line] = strtok(line);
            v(k) = eval(token);
        end
        if k > 3
            error('Read vertex with more than 3 coordinates.');
        end
        mesh.V(:, numverts) = v;
    elseif strcmp(token, 'f')
      
            ll = line;
            
        numfaces = numfaces + 1;
        k = 0;
        while k < 3 && ~isempty(line)
            k = k + 1;
            [token,line] = strtok(line);
            token = strtok(token,'/');
            f(k) = str2num(token);
        end
        if k > 3
            error('Read face with more than 3 indices.');
        end
        %disp( sprintf( '%s :: %i / %i / %i', ll, f(1), f(2), f(3)));
        mesh.F(:, numfaces) = f;
    end
    
end
fclose(file);

mesh.V = mesh.V([1,3,2,4],:);
mesh.V(2,:) = -mesh.V(2,:);

mesh.V = mesh.V(:, 1:numverts);
mesh.F = mesh.F(:, 1:numfaces);

%pack;