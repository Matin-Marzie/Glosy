import express from 'express';
import userController from '../../controllers/userController.js';
import syncController from '../../controllers/syncController.js';
import verifyJWT from '../../middleware/verifyJWT.js';
import optionalVerifyJWT from '../../middleware/optionalVerifyJWT.js';
import { profilePictureLimiter } from '../../middleware/rateLimiter.js';

const router = express.Router();

/**
 * @swagger
 * /user/me:
 *   get:
 *     summary: Get current user's profile and progress
 *     description: Retrieve authenticated user's profile, progress (energy, coins, languages), and learned vocabulary for current language
 *     tags: [User]
 *     security:
 *       - bearerAuth: []
 *       - cookieAuth: []
 *     responses:
 *       200:
 *         description: User profile and progress fetched successfully
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/UserProfileProgressResponse'
 *       404:
 *         description: User not found
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Error'
 *       401:
 *         description: Unauthorized - Missing or invalid token
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Error'
 *       500:
 *         description: Internal server error
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Error'
 */
router.get('/me', verifyJWT, userController.getUserProfileProgress);

/**
 * @swagger
 * /user/{id}:
 *   get:
 *     summary: Get user profile by ID
 *     description: Retrieve public profile information for a user by their ID
 *     tags: [User]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *         description: User ID
 *     responses:
 *       200:
 *         description: User profile retrieved successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                   example: true
 *                 data:
 *                   type: object
 *                   properties:
 *                     user:
 *                       $ref: '#/components/schemas/User'
 *       404:
 *         description: User not found
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Error'
 *       500:
 *         description: Internal server error
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Error'
 */
router.get('/:id', userController.getUserById);

/**
 * @swagger
 * /user/{id}/reels:
 *   get:
 *     summary: Get a user's published reels
 *     description: Retrieve a user's own reels (public - no auth required), most recent first. If the caller is authenticated, each reel's user_interaction reflects the caller's own like/save state.
 *     tags: [User]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *         description: User ID
 *       - in: query
 *         name: limit
 *         schema:
 *           type: integer
 *           default: 30
 *           maximum: 50
 *         description: Maximum number of reels to return
 *     responses:
 *       200:
 *         description: Reels retrieved successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                   example: true
 *                 data:
 *                   type: object
 *                   properties:
 *                     reels:
 *                       type: array
 *                       items:
 *                         type: object
 *       400:
 *         description: Invalid user id
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Error'
 *       500:
 *         description: Internal server error
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Error'
 */
router.get('/:id/reels', optionalVerifyJWT, userController.getUserReels);

/**
 * @swagger
 * /user/profile:
 *   patch:
 *     summary: Update current user's profile
 *     description: Update user profile information (username, email, language preferences)
 *     tags: [User]
 *     security:
 *       - bearerAuth: []
 *       - cookieAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/UpdateProfileRequest'
 *     responses:
 *       200:
 *         description: Profile updated successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: 'Profile updated successfully'
 *                 data:
 *                   type: object
 *                   properties:
 *                     user:
 *                       $ref: '#/components/schemas/User'
 *       400:
 *         description: Invalid request data or no valid fields to update
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Error'
 *       401:
 *         description: Unauthorized - Missing or invalid token
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Error'
 *       409:
 *         description: Username already taken
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Error'
 *       500:
 *         description: Internal server error
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Error'
 */
router.patch('/profile', verifyJWT, userController.updateProfile);

/**
 * @swagger
 * /user/profile-picture/upload-url:
 *   post:
 *     summary: Get a presigned URL for uploading a profile picture
 *     description: Returns a presigned CDN URL the client uploads the image to directly (HTTP PUT), plus the object key to confirm afterwards via PATCH /user/profile-picture
 *     tags: [User]
 *     security:
 *       - bearerAuth: []
 *       - cookieAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required: [contentType, size]
 *             properties:
 *               fileName:
 *                 type: string
 *                 description: Original file name, used to derive the object key's extension
 *               contentType:
 *                 type: string
 *                 description: Image MIME type
 *                 example: image/jpeg
 *               size:
 *                 type: integer
 *                 description: File size in bytes (maximum 5MB)
 *     responses:
 *       200:
 *         description: Presigned upload URL created
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 key:
 *                   type: string
 *                   description: Object key to send to PATCH /user/profile-picture once the upload completes
 *                 url:
 *                   type: string
 *                   description: Presigned URL to PUT the image to
 *       400:
 *         description: Invalid image type or file larger than 5MB
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Error'
 *       401:
 *         description: Unauthorized - Missing or invalid token
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Error'
 *       429:
 *         description: Too many profile picture requests
 * /user/profile-picture:
 *   patch:
 *     summary: Set current user's profile picture from an uploaded file
 *     description: Confirms an image uploaded via the presigned URL from POST /user/profile-picture/upload-url and sets it as the authenticated user's profile picture, deleting any previous one uploaded by the user
 *     tags: [User]
 *     security:
 *       - bearerAuth: []
 *       - cookieAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required: [key]
 *             properties:
 *               key:
 *                 type: string
 *                 description: Object key returned by POST /user/profile-picture/upload-url
 *     responses:
 *       200:
 *         description: Profile picture updated successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: 'Profile picture updated successfully'
 *                 data:
 *                   type: object
 *                   properties:
 *                     user:
 *                       $ref: '#/components/schemas/User'
 *       400:
 *         description: Missing or invalid key
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Error'
 *       401:
 *         description: Unauthorized - Missing or invalid token
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Error'
 *       500:
 *         description: Internal server error
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Error'
 */
router.post('/profile-picture/upload-url', verifyJWT, profilePictureLimiter, userController.presignProfilePicture);
router.patch('/profile-picture', verifyJWT, profilePictureLimiter, userController.updateProfilePicture);

/**
 * @swagger
 * /user/profile-picture:
 *   delete:
 *     summary: Remove current user's profile picture
 *     description: Removes the authenticated user's profile picture, reverting them to the default initial-letter avatar
 *     tags: [User]
 *     security:
 *       - bearerAuth: []
 *       - cookieAuth: []
 *     responses:
 *       200:
 *         description: Profile picture removed successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: 'Profile picture removed successfully'
 *                 data:
 *                   type: object
 *                   properties:
 *                     user:
 *                       $ref: '#/components/schemas/User'
 *       400:
 *         description: No profile picture to remove
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Error'
 *       401:
 *         description: Unauthorized - Missing or invalid token
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Error'
 *       500:
 *         description: Internal server error
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Error'
 */
router.delete('/profile-picture', verifyJWT, userController.deleteProfilePicture);

/**
 * @swagger
 * /user/me:
 *   delete:
 *     summary: Delete current user's account
 *     description: Permanently delete the authenticated user's account and all associated data (languages, vocabulary progress). This action is irreversible.
 *     tags: [User]
 *     security:
 *       - bearerAuth: []
 *       - cookieAuth: []
 *     responses:
 *       200:
 *         description: Account deleted successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: 'Account deleted successfully'
 *       401:
 *         description: Unauthorized - Missing or invalid token
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Error'
 *       404:
 *         description: User not found
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Error'
 *       500:
 *         description: Internal server error
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Error'
 */
router.delete('/me', verifyJWT, userController.deleteAccount);


/**
 * @swagger
 * /user/sync:
 *   post:
 *     summary: Sync user progress and vocabulary changes
 *     description: Synchronize frontend data with backend including user progress (energy, coins) and vocabulary changes (inserts, updates, deletes)
 *     tags: [User]
 *     security:
 *       - bearerAuth: []
 *       - cookieAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               user_progress:
 *                 type: object
 *                 properties:
 *                   energy:
 *                     type: integer
 *                     minimum: 0
 *                     maximum: 100
 *                   coins:
 *                     type: integer
 *                     minimum: 0
 *                   current_user_languages_id:
 *                     type: integer
 *               vocabulary_changes:
 *                 type: object
 *                 properties:
 *                   inserts:
 *                     type: object
 *                   updates:
 *                     type: object
 *                   deletes:
 *                     type: object
 *     responses:
 *       200:
 *         description: Sync completed successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                 results:
 *                   type: object
 *       400:
 *         description: Validation error
 *       500:
 *         description: Internal server error
 */
router.post('/sync', verifyJWT, syncController.sync);

export default router;

