% SESSION_APPEND adds session struct from session_parser to end of database struct
function db = session_append(session, db)
% MJP 11/10/2021

if ~isfield(db, 'session') % Format db if first session
    session_id = num2cell(ones(length(session),1));
    [session.session] = session_id{:};
    db = session;
else
    session_id = num2cell(db(end).session+1*ones(length(session),1));
    [session.session] = session_id{:};
    db = [db,session];
end
end