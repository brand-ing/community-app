import { Router } from 'express';

const router = Router();

// GET /api/me — proves the app and backend are synced:
// the Flutter app sends its Auth0 token, the backend verifies it and answers.
router.get('/', (req, res) => {
  const { sub, scope } = req.auth.payload;
  res.json({
    message: 'Backend verified your login 🎉',
    userId: sub, // stable Auth0 user id — use this as the key in the database later
    scope: scope || null,
  });
});

export default router;
