function [ ] = writeMatrixOfStringsToFile( mat_str, file_name )
fid=fopen(file_name,'wt');
[rows,cols]=size(mat_str)
for i = 1:rows
    for j=1:cols
        s = mat_str(i,j);
        if(j > 1)
            fprintf(fid, ',');
        end
        fprintf(fid,'%s',s{1:end})
    end
    fprintf(fid, '\n');
end

end

