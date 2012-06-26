#!/bin/sh

# Updates etc at: https://github.com/camelmasa/Tar-to-Amazon-S3
# Under a MIT license

# change these variables to what you need
S3BUCKET=

#tar path.
TAR_PATH=/path/to/tar

#tmp path.
TMP_PATH=/path/to/tmp
PERIOD=${1-day}

echo "Starting backing up the files to a zip..."
echo "Starting compression..."

tar czvf ${TMP_PATH}backup.tar.gz ${ZIP_PATH}

echo "Done compressing the backup file."

echo "Removing old backup (2 ${PERIOD}s ago)..."
s3cmd del --recursive s3://${S3BUCKET}/previous${PERIOD}/
echo "Old backup removed."

echo "Moving the backup from past $PERIOD to another folder..."
s3cmd mv --recursive s3://${S3BUCKET}/${PERIOD}/ s3://${S3BUCKET}/previous${PERIOD}/
echo "Past backup moved."

echo "Uploading the new backup..."
s3cmd put -f ${TMP_PATH}backup.tar.gz s3://${S3BUCKET}/${PERIOD}/
echo "New backup uploaded."

echo "Removing the cache files..."
rm ${TMP_PATH}backup.tar.gz
echo "Files removed."
echo "All done."
