% MATLAB Script for running LAMMPS multiple times

count = 0;
for i = 3.0:0.10:5.0
   command_line = ['lmp_serial -var latconst ' num2str(i) ' < calc_fcc_ver1.in'];

   % this next line executes the command line
   system(command_line) 

   % all that is left is to mine the 'log.lammps' file for the energy
   fid = fopen('log.lammps');
        tline = fgetl(fid);
        while ~feof(fid)  % explanation: https://www.mathworks.com/help/matlab/ref/feof.html
           matches = strfind(tline, '%%');
           num = length(matches);
           if num > 0 && matches == 1
                teval = strrep(tline,'%%','');
                eval(teval)
           end
           tline = fgetl(fid);
        end
    fclose(fid);

   % store the values in a matrix
   count = count + 1;
   X(count) = i; Y(count) = ecoh;
end

plot(X,Y,'-*r'), axis square

% comment to test git status!