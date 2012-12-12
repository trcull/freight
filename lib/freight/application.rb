require 'optparse'
require 'ostruct'

module Freight

  ######################################################################
  # Freight main application object.  When invoking +freight+ from the
  # command line, a Freight::Application object is created and run.
  #
  #
  # Special thanks to Jim Weirich and 'rake' for providing an example to emulate
  class Application
    # The name of the application (typically 'freight')
    attr_reader :name

    # The original directory where freight was invoked.
    attr_reader :original_dir

    # Name of the actual freightfile used.
    attr_reader :freightfile

    DEFAULT_FREIGHTFILES = ['freightfile', 'Freightfile', 'freightfile.rb', 'Freightfile.rb'].freeze

    # Initialize a Freight::Application object.
    def initialize
      super
      @name = 'freight'
      @freightfiles = DEFAULT_FREIGHTFILES.dup
      @freightfile = nil
    end

    # Run the Freight application.  The run method performs the following
    # two steps:
    #
    # * Initialize the command line options (+init+).
    # * Define the message channels, endpoints, and transforms (+load_freightfile+).
    #
    def run
      standard_exception_handling do
        init
        load_freightfile
        start_messages
      end
    end
    
    # Initialize the command line parameters and app name.
    def init(app_name='freight')
      standard_exception_handling do
        @name = app_name
        handle_options
        trace "Reading message channels" unless options.silent
        collect_message_channels
        trace "Done reading message channels" unless options.silent
      end
    end
    
    # Find the freightfile and then load it
    def load_freightfile
      standard_exception_handling do
        #TODO: set @freightfile
      end
    end    

    # Open the floodgates and let messages flow
    def start_messages
      run_with_threads do
        #TODO
      end
    end
  
    def collect_message_channels
      #TODO
    end
    

    # Application options from the command line
    def options
      @options ||= OpenStruct.new
    end
        
   # spawn a new thread and run the given block in it
    def run_with_threads
      #TODO: use a thread pool
      yield
    end    
    
    # Provide standard exception handling for the given block.
    def standard_exception_handling
      begin
        yield
      rescue SystemExit => ex
        # Exit silently with current status
        raise
      rescue OptionParser::InvalidOption => ex
        $stderr.puts ex.message
        exit(false)
      rescue Exception => ex
        # Exit with error message
        display_error_message(ex)
        exit(false)
      end
    end    
    
    # Display the error message that caused the exception.
    def display_error_message(ex)
      trace "#{name} aborted!"
      trace ex.message
      if options.backtrace
        trace ex.backtrace.join("\n")
      else
        trace Backtrace.collapse(ex.backtrace).join("\n")
      end
      trace "(See full trace by running task with --trace)" unless options.backtrace
    end
    
    def trace(*strings)
      puts strings
    end    
    
    def sort_options(options)
      options.sort_by { |opt|
        opt.select { |o| o =~ /^-/ }.map { |o| o.downcase }.sort.reverse
      }
    end
    private :sort_options

    # A list of all the standard options used in freight, suitable for
    # passing to OptionParser.
    def standard_freight_options
      sort_options(
        [
          ['--libdir', '-I LIBDIR', "Include LIBDIR in the search path for required modules.",
            lambda { |value| $:.push(value) }
          ],
          ['--freightfile', '-f [FILE]', "Use FILE as the freightfile.",
            lambda { |value|
              value ||= ''
              @freightfiles.clear
              @freightfiles << value
            }
          ],
          ['--silent', '-s', "Don't output anything'",
            lambda { |value|
              Freight.verbose(false)
            }
          ],
          ['--verbose', '-v', "Log message to standard output.",
            lambda { |value| Freight.verbose(true) }
          ],
          ['--version', '-V', "Display the program version.",
            lambda { |value|
              puts "freight, version #{FREIGHTVERSION}"
              exit
            }
          ],
        ])
    end
    
    # Read and handle the command line options.
    def handle_options
      OptionParser.new do |opts|
        opts.banner = "freight [-f freightfile] {options} "
        opts.separator ""
        opts.separator "Options are ..."

        opts.on_tail("-h", "--help", "-H", "Display this help message.") do
          puts opts
          exit
        end

        standard_freight_options.each { |args| opts.on(*args) }
        opts.environment('FREIGHTOPT')
      end.parse!
    end    
  end
  
  @@application = Freight::Application.new
  def self.application
    @@application
  end
    
end    
    
    
