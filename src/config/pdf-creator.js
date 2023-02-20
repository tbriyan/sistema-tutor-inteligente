const path = require("path");
module.exports = {
    options : {
        //phantomPath: path.join(__dirname, '../../node_modules/phantomjs-prebuilt/bin/phantomjs'),
        format: "Letter",
        orientation: "portrait",
        border: "10mm",
        header: {
            height: "40mm",
            contents: `<div style="height: 100px;display: flex;justify-content: space-between;">
            <div>
            </div>
            <div style="text-align: center;">
              <h1>Unidad Educativa</h1>
              <h3>Marcelo Quiroga Santa Cruz</h3>
            </div>
            <div></div>
          </div>`
        }
    }
}