%%TIMIT_MIT_Database should create a new GUI
f = TIMIT_MIT_Database();
assert(strcmp(f.DefaultDirectory, '../TIMIT MIT/'), 'Wrong DefaultDirectory');
assert(ishandle(f.GUI.Handles.hFigure), 'No Figure was created');
assert(~isempty('f.Database'), 'No Database was loaded');
assert(exist('TIMIT_MIT_Database') == 2, 'The class TIMIT_MIT_Database does not exist');
assert(exist(f.DefaultDirectory,'dir') == 7, 'The DefaultDirectory does not exist');