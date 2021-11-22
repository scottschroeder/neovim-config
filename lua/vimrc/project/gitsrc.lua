local Job = require("plenary.job")
local log = require("vimrc.log")



-- fd -H --base-directory ~/src --type d '\.git$' . -x echo {//}
--
local function kickoff_fetch(base_dir)
  Job:new({
    command = "fd",
    args = {
      '-H',
      '--base-directory',
      base_dir,
      '--type',
      'd',
      '\\.git$',
      '.',
      '-x',
      'echo',
      '{//}'
    },
    on_exit=function(j, return_val)
      if return_val > 0 then
        log.warn("unable to run `fd`")
        return
      end
      -- log.trace("stdout?", j:result())


    end,
  }):start()
end

local M = {}
function M.demo()
  pcall(kickoff_fetch,"/home/scott/src")
end
return M
