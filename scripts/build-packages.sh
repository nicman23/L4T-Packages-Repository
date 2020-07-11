#/bin/bash

WORKDIR=$(dirname $(dirname $(readlink -fm $0)))

select $manager in pkgbuild rpmbuild apkbuild portage; do
    case $manager in
    pkgbuild)
        docker run -rm --it \
            --volume $WORKDIR:/root/workspace \
            --user root \
            --workdir //root/workspace \
            archlinux \
            ./scripts/packages/arch.sh
    ;;
    rpmbuild)
        select $distro in fedora leap tumbleweed centos; do
            case $distro in
            fedora)
                docker run -rm --it \
                    --volume $WORKDIR:/root/workspace \
                    --user root \
                    --workdir //root/workspace \
                    fedora \
                    ./scripts/packages/fedora.sh
            ;;
            leap)
                docker run -rm --it \
                    --volume $WORKDIR:/root/workspace \
                    --user root \
                    --workdir //root/workspace \
                    opensuse/leap \
                    ./scripts/packages/leap.sh
            ;;
            tumbleweed)
                docker run -rm --it \
                    --volume $WORKDIR:/root/workspace \
                    --user root \
                    --workdir //root/workspace \
                    opensuse/tumbleweed \
                    ./scripts/packages/tumbleweed.sh
            ;;
            centos)
                echo "Not implementend yet"
            ;;
            *)
                echo "Invalid entry."
                exit
            ;;
            esac
            break
        done
    ;;
    apkbuild)
        echo "Not implementend yet"
    ;;
    portage)
        echo "Not implementend yet"
    ;;
    *)
        echo "Invalid entry."
        exit
    ;;
    esac
    break
done