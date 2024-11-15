# FFmpeg build

Build FFmpeg as static binary with no external dependencies in a container based on Debian.

## How to build/create container

Within the repo with the `Containerfile`:

    mkdir ffmpeg_root
    podman build --target build -t ffmpeg-builder .
    
Results will be placed in `ffmpeg_root/`. Now manually initiate the
FFmpeg building process:

    podman run --rm -v ./ffmpeg_root:/ffmpeg_root ffmpeg-builder ffmpeg-build
    
And create the final ffmpeg container:
    
    podman build --target release -t ffmpeg .
    
Now you can safely delete `ffmpeg_root/` and the `ffmpeg-builder` image.

## Run FFmpeg in container

    podman run --rm ffmpeg -buildconf
    podman run --rm ffmpeg -codecs
    podman run --rm -v $(pwd):$(pwd) -w $(pwd) ffmpeg
    podman run --rm -it -v $(pwd):$(pwd) -w $(pwd) ffmpeg -i input.mp4 -c:v libx264 -preset medium -crf 22 -profile:v main -c:a libfdk_aac -b:a 192k -f mp4 output.mp4
