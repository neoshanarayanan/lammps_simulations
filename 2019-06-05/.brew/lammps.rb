class Lammps < Formula
  desc "Molecular Dynamics Simulator"
  homepage "https://lammps.sandia.gov/"
  url "https://lammps.sandia.gov/tars/lammps-5Jun19.tar.gz"
  # lammps releases are named after their release date. We transform it to
  # YYYY-MM-DD (year-month-day) so that we get a sane version numbering.
  # We only track stable releases as announced on the LAMMPS homepage.
  version "2019-06-05"
  sha256 "5356c51cbc11e0e0e1b5947b772c1520b5008f347e5f4d59003a71ec5aaf72ec"

  depends_on "pkg-config" => :build
  depends_on "fftw"
  depends_on "gcc" # for gfortran
  depends_on "jpeg"
  depends_on "kim-api"
  depends_on "libpng"
  depends_on "open-mpi"

  def install
    %w[serial mpi].each do |variant|
      cd "src" do
        system "make", "clean-all"
        system "make", "yes-standard"

        # Disable some packages for which we do not have dependencies, that are
        # deprecated or require too much configuration.
        %w[gpu kokkos latte mscg message mpiio poems voronoi].each do |package|
          system "make", "no-#{package}"
        end

        system "make", variant,
                       "LMP_INC=-DLAMMPS_GZIP",
                       "FFT_INC=-DFFT_FFTW3 -I#{Formula["fftw"].opt_include}",
                       "FFT_PATH=-L#{Formula["fftw"].opt_lib}",
                       "FFT_LIB=-lfftw3",
                       "JPG_INC=-DLAMMPS_JPEG -I#{Formula["jpeg"].opt_include} " \
                       "-DLAMMPS_PNG -I#{Formula["libpng"].opt_include}",
                       "JPG_PATH=-L#{Formula["jpeg"].opt_lib} -L#{Formula["libpng"].opt_lib}",
                       "JPG_LIB=-ljpeg -lpng"

        bin.install "lmp_#{variant}"
      end
    end

    pkgshare.install(%w[doc potentials tools bench examples])
  end

  test do
    system "#{bin}/lmp_serial", "-in", "#{pkgshare}/bench/in.lj"
  end
end
