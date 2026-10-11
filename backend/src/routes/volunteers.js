import { Router } from 'express';
export function createVolunteersRouter(getPool) {
  const router = Router();
  router.get('/', async (_req,res,next) => {
    try { res.json({ volunteers: (await getPool().query('SELECT id,display_name AS "displayName",categories,skills,support_modes AS "supportModes",location,availability,bio,is_demo AS "isDemo" FROM volunteers ORDER BY display_name LIMIT 100')).rows }); } catch(error) { next(error); }
  });
  return router;
}
export function createOpportunitiesRouter(getPool) {
  const router = Router();
  router.get('/', async (_req,res,next) => {
    try { res.json({ opportunities:(await getPool().query('SELECT id,title,host,category,time_label AS time,location_label AS location,description,is_demo AS "isDemo" FROM opportunities ORDER BY created_at,id LIMIT 100')).rows }); } catch(error) { next(error); }
  });
  return router;
}
