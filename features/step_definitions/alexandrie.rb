When(/^he add a new document$/) do
  attach_file :attachment_file, Dorsale::Engine.root.join("spec/files/pdf.pdf"), visible: :all
  find("#new_attachment [type=submit]").click
end

When(/^he delete a document$/) do
  all(".attachment .link_delete").first.click
end

When(/^he update the document$/) do
  find(".attachment [href$=edit]").click
  fill_in :attachment_name, with: "new document name"
  find("#edit_attachment [type$=submit]").click
  sleep 1 # ajax
end

Then(/^the document is updated$/) do
  @attachment = Dorsale::Alexandrie::Attachment.reorder(:updated_at).last
  expect(@attachment.name).to eq "new document name"
end
