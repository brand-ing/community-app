BEGIN;
INSERT INTO volunteers(id,display_name,categories,skills,support_modes,location,availability,bio,is_demo) VALUES
('10000000-0000-4000-8000-000000000001','Jordan',ARRAY['gardening','errands'],ARRAY['Gardening','Light yard work'],ARRAY['in_person'],'Atlanta','Weekend mornings','Fictional volunteer for testing gardening requests.',true),
('10000000-0000-4000-8000-000000000002','Sam',ARRAY['tutoring','technology'],ARRAY['Math tutoring','Computer basics'],ARRAY['remote','in_person'],'Atlanta','Weekday evenings','Fictional volunteer for testing tutoring and technology requests.',true),
('10000000-0000-4000-8000-000000000003','Alex',ARRAY['companionship','food'],ARRAY['Friendly check-ins','Meal packing'],ARRAY['remote','in_person'],'Atlanta','Flexible; confirm before arranging help','Fictional volunteer for testing check-ins and community meals.',true)
ON CONFLICT(id) DO NOTHING;
INSERT INTO opportunities(id,title,host,category,time_label,location_label,description,is_demo) VALUES
('20000000-0000-4000-8000-000000000001','Lend a hand at a community garden','Neighborhood garden team','Volunteer','Weekend mornings','In person','Help plant, water, and care for a shared green space. No gardening experience needed.',true),
('20000000-0000-4000-8000-000000000002','Pack meals for neighbors','Community pantry','Volunteer','2-hour shifts','In person','Sort donations and prepare food packages alongside other volunteers.',true),
('20000000-0000-4000-8000-000000000003','Be a friendly check-in buddy','Neighbor connection group','Volunteer','Flexible schedule','Remote','Make time for a friendly conversation with someone who could use company.',true),
('20000000-0000-4000-8000-000000000004','Help with a small yard project','Community member','Odd jobs','One-time task','In person','Offer light yard work. Scope and payment would be agreed with the requester.',true),
('20000000-0000-4000-8000-000000000005','Share your knowledge with a learner','Community member','Tutoring','Flexible schedule','Remote or in person','Help someone practice a subject you know. Session details and payment would be agreed together.',true),
('20000000-0000-4000-8000-000000000006','Take a neighbor''s dog for a walk','Community member','Pet care','Short visits','In person','Offer local dog walks or pet check-ins. Responsibilities and payment would be agreed with the owner.',true)
ON CONFLICT(id) DO NOTHING;
COMMIT;
