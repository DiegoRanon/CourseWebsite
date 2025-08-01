-- Enable RLS on the users table if not already enabled
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;

-- Politiques pour le bucket profile-picture
-- Ces politiques permettent aux utilisateurs de gérer leurs photos de profil

-- 1. Politique INSERT - Permettre aux utilisateurs authentifiés d'uploader leur photo de profil
CREATE POLICY "Allow authenticated users to upload profile pictures" ON storage.objects
FOR INSERT WITH CHECK (
  bucket_id = 'profile-picture' 
  AND auth.role() = 'authenticated'
  AND (storage.foldername(name))[1] = auth.uid()::text
);

-- 2. Politique SELECT - Permettre la lecture publique des photos de profil
CREATE POLICY "Allow public read access to profile pictures" ON storage.objects
FOR SELECT USING (bucket_id = 'profile-picture');

-- 3. Politique UPDATE - Permettre aux utilisateurs de mettre à jour leur propre photo
CREATE POLICY "Allow users to update their own profile picture" ON storage.objects
FOR UPDATE USING (
  bucket_id = 'profile-picture' 
  AND auth.role() = 'authenticated'
  AND (storage.foldername(name))[1] = auth.uid()::text
);

-- 4. Politique DELETE - Permettre aux utilisateurs de supprimer leur propre photo
CREATE POLICY "Allow users to delete their own profile picture" ON storage.objects
FOR DELETE USING (
  bucket_id = 'profile-picture' 
  AND auth.role() = 'authenticated'
  AND (storage.foldername(name))[1] = auth.uid()::text
);

-- Politiques pour la table users
-- Ces politiques permettent aux utilisateurs de gérer leur profil

-- 1. Politique SELECT pour users - Permettre aux utilisateurs de lire leur propre profil
CREATE POLICY "Allow users to read own profile" ON public.users
FOR SELECT USING (auth.uid() = id);

-- 2. Politique SELECT pour users - Permettre la lecture publique des profils (informations limitées)
CREATE POLICY "Allow users to read public profile data" ON public.users
FOR SELECT USING (true);

-- 3. Politique UPDATE pour users - Permettre aux utilisateurs de mettre à jour leur propre profil
CREATE POLICY "Allow users to update own profile" ON public.users
FOR UPDATE USING (auth.uid() = id);

-- Note: Ces politiques garantissent que :
-- - Seuls les utilisateurs authentifiés peuvent uploader des photos
-- - Les photos sont organisées par dossier utilisateur (user_id/filename)
-- - Les utilisateurs ne peuvent modifier que leurs propres photos
-- - Les photos sont accessibles publiquement pour l'affichage 
-- - Les utilisateurs peuvent uniquement mettre à jour leur propre enregistrement dans la table users 