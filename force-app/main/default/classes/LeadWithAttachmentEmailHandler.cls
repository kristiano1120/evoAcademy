global class LeadWithAttachmentEmailHandler implements Messaging.InboundEmailHandler {
	global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
    
        try {
            Lead senderLead = [SELECT Id, Name, Email FROM Lead WHERE Email = :email.subject LIMIT 1];
            
            Messaging.InboundEmail.BinaryAttachment[] bAttachments = email.binaryAttachments;
            List<Attachment> attachments = new List<Attachment>();
            if(bAttachments != null){
                for (Messaging.Inboundemail.BinaryAttachment mailAttachment: bAttachments) {
                    Blob body = mailAttachment.body;
                    Attachment attachment = new Attachment();
                    attachment.Name = mailAttachment.fileName;
                    attachment.Body = body;
                    attachment.ParentId = senderLead.Id;
                    attachments.add(attachment);
            	}
                
            }
            insert attachments;
    
            result.success = true;
        } catch (Exception e) {
            result.success = false;
            result.message = 'Failed to insert Lead.' + e.getMessage();
        }
        return result;
	}
}