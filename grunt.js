module.exports = function(grunt) {

    // TODO: Provide copy of these grunt tasks.
    grunt.loadTasks( "../../quickui/grunt" );

    // Project configuration.
    grunt.initConfig({
        coffee: {
            controls: {
                src: [
                    // Base classes come first
                    "controls/Card.coffee",
                    "controls/FieldLauncher.coffee",
                    // More specific classes
                    "controls/ContactCard.coffee",
                    "controls/ContactDetails.coffee",
                    "controls/ContactListBox.coffee",
                    "controls/ContactsPage.coffee",
                    "controls/DetailsReader.coffee",
                    "controls/DetailsEditor.coffee",
                    "controls/EmailAddress.coffee",
                    "controls/PostalAddress.coffee",
                    "controls/Toolbar.coffee",
                    "models/*.coffee",
                    "presenters/*.coffee"
                ],
                dest: "contacts.js"
            },
            test: {
                src: "test/*.coffee",
                dest: "test/unittests.js"
            }
        },
        less: {
            controls: {
                src: "contacts.less",
                dest: "contacts.css"
            }
        },
        watch: {
            controls: {
                files: "<config:coffee.controls.src>",
                tasks: "coffee:controls"
            },
            test: {
                files: "<config:coffee.test.src>",
                tasks: "coffee:test"
            },
            less: {
                files: [ "*.less", "controls/*.less" ],
                tasks: "less"
            }
        }
    });

    // Default task.
    grunt.registerTask( "default", "coffee less" );
    
};
