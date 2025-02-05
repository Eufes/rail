	
#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.Имя = "ВходящееСообщение" Тогда		
		СтандартнаяОбработка = Ложь;
		ТекДанные = Элемент.ТекущиеДанные;
		Если ТекДанные <> Неопределено Тогда
			ПараметрыОткрытия = Новый Структура("Ключ", ТекДанные.ВходящееСообщение);
			ОткрытьФорму("Справочник.MultiPort_СообщенияВходящие.Форма.ФормаЭлемента", ПараметрыОткрытия);					
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

