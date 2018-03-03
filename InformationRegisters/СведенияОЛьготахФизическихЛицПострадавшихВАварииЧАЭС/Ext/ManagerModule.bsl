﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Процедура УдалитьСведенияСНезаполненнымКоличествомДнейОтпуска() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	СведенияОЛьготахФизическихЛицПострадавшихВАварииЧАЭС.ФизическоеЛицо
		|ИЗ
		|	РегистрСведений.СведенияОЛьготахФизическихЛицПострадавшихВАварииЧАЭС КАК СведенияОЛьготахФизическихЛицПострадавшихВАварииЧАЭС
		|ГДЕ
		|	СведенияОЛьготахФизическихЛицПострадавшихВАварииЧАЭС.КоличествоДнейОтпуска = 0";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если Не РезультатЗапроса.Пустой() Тогда
		
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			
			НаборЗаписей = РегистрыСведений.СведенияОЛьготахФизическихЛицПострадавшихВАварииЧАЭС.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.ФизическоеЛицо.Установить(Выборка.ФизическоеЛицо);
			
			НаборЗаписей.Записать();
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли