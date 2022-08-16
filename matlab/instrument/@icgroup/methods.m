function varargout = methods(obj, varargin)
%METHODS Display class method names.
%
%   METHODS CLASSNAME displays the names of the methods for the
%   class with the name CLASSNAME.
% 
%   METHODS(OBJECT) displays the names of the methods for the class
%   of OBJECT.
% 
%   M = METHODS('CLASSNAME') returns the methods in a cell array of
%   strings.
% 
%   METHODS differs from WHAT in that the methods from all method
%   directories are reported together, and METHODS removes all
%   duplicate method names from the result list. METHODS will also
%   return the methods for a Java class.
% 
%   METHODS CLASSNAME -full  displays a full description of the
%   methods in the class, including inheritance information and,
%   for Java methods, also attributes and signatures. Duplicate
%   method names with different signatures are not removed.
%   If class_name represents a MATLAB class, then inheritance 
%   information is returned only if that class has been instantiated. 
% 
%   M = METHODS('CLASSNAME', '-full') returns the full method
%   descriptions in a cell array of strings.
%    
%   See also METHODSVIEW, WHAT, WHICH, HELP.
%

%   Copyright 1999-2016 The MathWorks, Inc. 

% convert to char in order to accept string datatype
varargin = instrument.internal.stringConversionHelpers.str2char(varargin);

% Error checking.
if (nargout > 1)
    error(message('instrument:icgroup:methods:maxlhs'));
end

if (nargin > 2)
    error(message('instrument:icgroup:methods:invalidSyntax'));
end

if ~isvalid(obj)
    error(message('instrument:icgroup:methods:invalidObj'));
end

if (nargin == 2)
    if ~strcmp(varargin{1}, '-full')
       error(message('instrument:icgroup:methods:invalidArg'));
    end
end

% Get the methods provided by the icgroup object.
methodNames = builtin('methods', obj);
methodNames = localCleanupMethodNames(methodNames);

% Get the methods provided by the icgroup object's driver.
jobj = igetfield(obj, 'jobject');
jobj = jobj(1);
driverMethodNames = getMethodNames(jobj);
if isempty(driverMethodNames)
    driverMethodNames = {};
else
    driverMethodNames = cell(driverMethodNames);
end

switch nargout    
case 0
    switch nargin
    case 1
		% Calculate the maximum method name.
		maxMethodLength = max(cellfun('length', methodNames));
        
        % Calculate the maximum driver name length.
        if isempty(driverMethodNames)
            maxDriverMethodLength = 0;
        else
        	maxDriverMethodLength = max(cellfun('length', driverMethodNames));
        end
        
        % Get the maximum method name.
		maxLength = max(maxMethodLength, maxDriverMethodLength);
		
		% Print out the method names.
		localPrettyPrint(methodNames, maxLength, ['Methods for class ' char(mclass(jobj)) ':']);
	
        % Print out the driver methods if they exist.
        if ~isempty(driverMethodNames)
        	localPrettyPrint(driverMethodNames, maxLength, ['Driver specific methods for class ' char(mclass(jobj)) ':']);
        else
            fprintf(['\nThere are no driver specific methods for class ' char(mclass(jobj)) '.\n']);
        end
	
        fprintf('\n\n');
    case 2
        % User passed the -full flag.
        out = '';
        for i = 1:length(methodNames)
            out = [out sprintf([methodNames{i} '\n'])];            
        end
        fprintf(out);
        
        % Print out the driver method signatures.
        out = '';
        for i = 1:length(driverMethodNames)
            out = [out sprintf([char(getMethodSignature(jobj, driverMethodNames{i})) ' %%%% Inherited from driver\n'])];
        end        
        fprintf([out '\n']);
    end
case 1
    switch nargin
        case 1
            allMethods = {methodNames{:} driverMethodNames{:}}';
            varargout{1} = sort(allMethods);
        case 2
            out = {};
            for i = 1:numel(driverMethodNames)
                temp =  char(getMethodSignature(jobj, driverMethodNames{i}));
                out{i}= sprintf('%s %% Inherited from driver', temp);
            end
            allMethods = {methodNames{:} out{:}};
            varargout{1} = allMethods';
    end
end

% ----------------------------------------------------------------
% Pretty print the methods.
function localPrettyPrint(methodNames, maxMethodLength, heading)

% Calculate spacing information.
maxColumns = floor(80/maxMethodLength);
maxSpacing = 2;
numOfRows = ceil(length(methodNames)/maxColumns);

% Reshape the methods into a numOfRows-by-maxColumns matrix.
numToPad = (maxColumns * numOfRows) - length(methodNames);
for i = 1:numToPad
    methodNames = {methodNames{:} ' '};
end
methodNames = reshape(methodNames, numOfRows, maxColumns);

% Print out the methods.
fprintf(['\n' heading '\n\n']);

% Loop through the methods and print them out.
for i = 1:numOfRows
    out = '';
    for j = 1:maxColumns
        m = methodNames{i,j};
        out = [out sprintf([m blanks(maxMethodLength + maxSpacing - length(m))])];
    end
    fprintf([out '\n']);
end

% ----------------------------------------------------------------
function methodNames = localCleanupMethodNames(methodNames)

% Remove loadobj and saveobj.
names = {'loadobj', 'saveobj', 'Contents', 'icinterface', 'close', 'igetfield', 'isetfield', 'open'};

for i=1:length(names)
    index = strmatch(names{i}, methodNames, 'exact');
    methodNames(index) = [];
end
