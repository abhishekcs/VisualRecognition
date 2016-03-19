function [ ] =writeArrayOfStringsToFile( arr_str, file_name )
fid=fopen(file_name,'wt');
[rows,cols]=size(arr_str)
for i=1:cols
      s = arr_str(i)
      fprintf(fid,'%s',s{1:end})
      fprintf(fid,'\n')
end
fclose(fid)


end

