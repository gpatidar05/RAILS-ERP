module NotesHelper
	def note_code(note)
		return "NOTE#{note.id.to_s.rjust(4, '0')}"
	end
end
