function [ s ] = own_xml2struct2( file )
    if (nargin < 1)
        clc;
        help xml2struct2
        return
    end
    
    if isa(file, 'org.apache.xerces.dom.DeferredDocumentImpl') || isa(file, 'org.apache.xerces.dom.DeferredElementImpl')
        % input is a java xml object
        xDoc = file;
        disp('Input is java xml object');
    else
        % check for existence
        disp('Input is not java xml object');
        if (exist(file,'file') == 0)
            % Perhaps the xml extension was omitted from the file name. Add the
            % extension and try again.
            if (isempty(strfind(file,'.xml')))
                file = [file '.xml'];
            end
            
            if (exist(file,'file') == 0)
                error(['The file ' file ' could not be found']);
            end
        end
        % read the xml file
        xDoc = xmlread(file);
    end
    
    % parse xDoc into a MATLAB structure
    s = parseRootNode(xDoc);
end

% ----- Subfunction parseRootNode -----
function root = parseRootNode(theNode)
    root = struct;
    rootName = toCharArray(getNodeName(theNode))';
    rootName = strrep(rootName, '-', '_dash_');
    rootName = strrep(rootName, ':', '_colon_');
    rootName = strrep(rootName, '.', '_dot_');
    root.(rootName) = parseChildNodes(theNode);
end

% ----- Subfunction parseChildNodes -----
function children = parseChildNodes(theNode)
    children = struct;
    if hasChildNodes(theNode)
        childNodes = getChildNodes(theNode);
        numChildNodes = getLength(childNodes);
        for count = 1:numChildNodes
            theChild = item(childNodes,count-1);
            [text,name,attr,childs] = getNodeData(theChild);
            
            if (~strcmp(name,'#text') && ~strcmp(name,'#comment') && ~strcmp(name,'#cdata_dash_section'))
                % XML allows the same elements to be defined multiple times,
                % put each in a different cell
                if (isfield(children,name))
                    if (~iscell(children.(name)))
                        % put existing element into cell format
                        children.(name) = {children.(name)};
                    end
                    index = length(children.(name))+1;
                    % add new element
                    children.(name){index} = childs;
                    if(~isempty(fieldnames(text)))
                        children.(name){index} = text;
                    end
                    if(~isempty(attr))
                        children.(name){index}.('Attributes') = attr;
                    end
                else
                    % add previously unknown (new) element to the structure
                    children.(name) = childs;
                    if(~isempty(text) && ~isempty(fieldnames(text)))
                        children.(name) = text;
                    end
                    if(~isempty(attr))
                        children.(name).('Attributes') = attr;
                    end
                end
            end
        end
    end
end

% ----- Subfunction getNodeData -----
function [text,name,attr,childs] = getNodeData(theNode)
    % Create structure of node info.
    name = toCharArray(getNodeName(theNode))';
    name = strrep(name, '-', '_dash_');
    name = strrep(name, ':', '_colon_');
    name = strrep(name, '.', '_dot_');
    attr = parseAttributes(theNode);
    
    % parse child nodes
    childs = parseChildNodes(theNode);
    
    if (isempty(fieldnames(childs)))
        % get the data of any childless nodes
        text = struct('Text', toCharArray(getTextContent(theNode))');
    else
        text = struct;
    end
end

% ----- Subfunction parseAttributes -----
function attributes = parseAttributes(theNode)
    % Create attributes structure.
    attributes = struct;
    if hasAttributes(theNode)
        theAttributes = getAttributes(theNode);
        numAttributes = getLength(theAttributes);
        for count = 1:numAttributes
            str = toCharArray(toString(item(theAttributes,count-1)))';
            k = strfind(str,'=');
            attr_name = str(1:(k(1)-1));
            attr_name = strrep(attr_name, '-', '_dash_');
            attr_name = strrep(attr_name, ':', '_colon_');
            attr_name = strrep(attr_name, '.', '_dot_');
            attributes.(attr_name) = str((k(1)+2):(end-1));
        end
    end
end
