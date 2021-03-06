% startup file to set environment for climada
% (c) David N. Bresch, 2008, 2014, 2016, 2017, david.bresch@gmail.com
% 20160122: 2nd level of sub-folders for code added
% 20160323: omit clc
% 20160609: do not add climada core's code/old any more
% 20161010: empty modules dir added
% 20170108: hint to climada_git_pull added
% 20170424: \t replaced by 2 spaces in output
%
% define the climada root directory
% --------------------------------
climada_root_dir=pwd; % current directory (print working directory)
%
% clc % clear command window

% create the dir to find the additional modules
climada_modules_dir=[climada_root_dir filesep 'modules'];
if ~exist(climada_modules_dir,'dir')
    climada_modules_dir=[fileparts(climada_root_dir) filesep 'climada_modules'];
end

% add to MATLAB path for code
% these last to be top in path list
addpath([climada_root_dir filesep 'code']);
addpath([climada_root_dir filesep 'code' filesep 'helper_functions']);
addpath([climada_root_dir filesep 'code' filesep 'data_import']);
%addpath([climada_root_dir filesep 'code' filesep 'old']); % 20160609

% pass the global root directory
global climada_global
climada_global.root_dir = deblank(climada_root_dir);

if exist(climada_modules_dir,'dir')
    climada_global.modules_dir = deblank(climada_modules_dir);
    fprintf('climada modules found: \n');
    add_dir  = dir(climada_modules_dir);
    for a_i = 1:length(add_dir)
        if length(add_dir(a_i).name)>2 && exist([climada_modules_dir filesep add_dir(a_i).name filesep 'code'],'dir')
            addpath([climada_modules_dir filesep add_dir(a_i).name filesep 'code']);
            fprintf('  %s\n',add_dir(a_i).name);
            
            % checking for sub-folders within code (only one level)
            sub_dir=[climada_modules_dir filesep add_dir(a_i).name filesep 'code'];
            add_subdir  = dir(sub_dir);
            for as_i = 1:length(add_subdir)
                if add_subdir(as_i).isdir && length(add_subdir(as_i).name)>2 ...
                        && isempty(strfind(add_subdir(as_i).name,'@')) && isempty(strfind(add_subdir(as_i).name,'private'))
                    addpath([sub_dir filesep add_subdir(as_i).name]);
                    fprintf('    %s\n',add_subdir(as_i).name);
                    
                    
                    % checking for sub-folders within code (only one more level)
                    subsub_dir=[sub_dir filesep add_subdir(as_i).name];
                    add_subsubdir  = dir(subsub_dir);
                    for ass_i = 1:length(add_subsubdir)
                        if add_subsubdir(ass_i).isdir && length(add_subsubdir(ass_i).name)>2 ...
                                && isempty(strfind(add_subsubdir(ass_i).name,'@')) && isempty(strfind(add_subsubdir(ass_i).name,'private'))
                            addpath([subsub_dir filesep add_subsubdir(ass_i).name]);
                            fprintf('      %s\n',add_subsubdir(ass_i).name);
                        end
                    end
                    
                    
                end
            end
            clear add_subdir as_i sub_dir add_subsubdir ass_i subsub_dir
            
        end
    end
    clear add_dir a_i
else
    climada_global.modules_dir = ''; % empty to signify not present
end

fprintf('initializing climada... ');

%initialises the global variables
climada_init_vars;

if strcmp(computer,'GLNXA64'),climada_global.waitbar=0;end % NCAR

fprintf('done (consider running climada_git_pull every now and then, at least weekly)\n');