﻿#Область ПрограммныйИнтерфейс

// Определяет принадлежит ли страна к списку стран оффшоров на основании макета.
//(см. макет РегистрыСведений.ДанныеПоКонтрагентамКонтролируемыхСделок.ПереченьОфшоров).
// Параметры:
//	Страна - СправочникСсылка.СтраныМира - если не заполнено - всегда возвращается Ложь.
// Возвращаемое значение:
//	Булево - Истина, если код переданной страны найден в макете "Перечень оффшоров", Ложь - в противном случае.
Функция СтранаЯвляетсяОфшором(Страна) Экспорт
	
	Если ТипЗнч(Страна) = Тип("СправочникСсылка.СтраныМира") И Не Страна.Пустая() Тогда
		
		КодСтраны = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Страна, "Код");
	
		Макет = РегистрыСведений.ДанныеПоКонтрагентамКонтролируемыхСделок.ПолучитьМакет("ПереченьОфшоров");
		ОбластьМакета = Макет.ПолучитьОбласть("ПереченьТерриторий");
		
		Для Ном = 1 По ОбластьМакета.ВысотаТаблицы Цикл
			ТекКод = ОбластьМакета.Область(Ном,1, Ном, 1).Текст;
			Если КодСтраны = СокрЛП(ТекКод) Тогда
				Возврат Истина;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

// Возвращает список кодов стран оффшоров.
// (см. макет РегистрыСведений.ДанныеПоКонтрагентамКонтролируемыхСделок.ПереченьОфшоров).
// Возвращаемое значение:
// Массив - список кодов из макета "Перечень оффшоров".
Функция ПереченьКодовСтранОфшоров() Экспорт
	
	Возврат ПолучитьСписокИзМакета("ПереченьОфшоров", "ПереченьТерриторий", "РегистрСведений.ДанныеПоКонтрагентамКонтролируемыхСделок").ВыгрузитьЗначения();
	
КонецФункции

// Возвращает список кодов ТНВЭД, которые принадлежат с товарам мировой биржевой торговли, на основании макета.
// (см. макет Обработка.ПомощникПодготовкиУведомленияОКонтролируемыхСделках.ТоварыМировойБиржевойТорговли).
// Возвращаемое значение:
// Массив - список кодов из макета "Товары мировой биржевой торговли".
Функция ПереченьКодовТНВЭДМировойБиржевойТорговли() Экспорт
	
	Возврат ПолучитьСписокИзМакета("ТоварыМировойБиржевойТорговли", "ПереченьКодовТНВЭД", "Обработка.ПомощникПодготовкиУведомленияОКонтролируемыхСделках").ВыгрузитьЗначения();
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьСписокКодовНаименованийСделки() Экспорт
	
	Возврат ПолучитьСписокИзМакета("КонтролируемыеСделкиСпискиКодов", "ТипИСтороныДоговора", "Обработка.ПомощникПодготовкиУведомленияОКонтролируемыхСделках");
	
КонецФункции

Функция ПолучитьСоответствиеКодовСтороныСделки() Экспорт
	
	СоответствиеКодов = Новый Соответствие();
	
	Макет = Обработки.ПомощникПодготовкиУведомленияОКонтролируемыхСделках.ПолучитьМакет("КонтролируемыеСделкиСпискиКодов");
	ОбластьМакета = Макет.ПолучитьОбласть("ТипИСтороныДоговора");
	
	Для Ном = 1 По ОбластьМакета.ВысотаТаблицы Цикл
		КодНаименованияСделки = ОбластьМакета.Область(Ном,1, Ном, 1).Текст;
		СписокКодов = Новый СписокЗначений();
		Для Колонка = 2 по 4 Цикл
			Код = ОбластьМакета.Область(Ном, Колонка*2 - 1 , Ном, Колонка*2 - 1).Текст;
			Наименование = ОбластьМакета.Область(Ном, Колонка*2, Ном, Колонка*2).Текст;
			Если ЗначениеЗаполнено(Код) Тогда
				СписокКодов.Добавить(Код, "" + Код + " - " + Наименование);
			КонецЕсли;
		КонецЦикла;
		СоответствиеКодов.Вставить(КодНаименованияСделки, СписокКодов);
	КонецЦикла;
	
	Возврат СоответствиеКодов;
	
КонецФункции

Функция ПолучитьКодыУсловийПоставки() Экспорт
	
	Возврат ПолучитьСписокИзМакета("КонтролируемыеСделкиСпискиКодов", "КодУсловийПоставки", "Обработка.ПомощникПодготовкиУведомленияОКонтролируемыхСделках");
	
КонецФункции

Функция ПолучитьКодыВидовДеятельностиФизЛиц() Экспорт
	
	Возврат ПолучитьСписокИзМакета("КонтролируемыеСделкиСпискиКодов", "КодВидаДеятельности", "Обработка.ПомощникПодготовкиУведомленияОКонтролируемыхСделках");
	
КонецФункции

Функция ПолучитьКодВидаДокументаПоВидуДокумента(ДокументВид) Экспорт 
	
	Если ЗначениеЗаполнено(ДокументВид) Тогда
		Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументВид, "КодМВД");
	Иначе
		Возврат "";
	КонецЕсли;
	
КонецФункции

Функция ПолучитьКодыОпределенияЦеныСделки() Экспорт
	
	Возврат ПолучитьСписокИзМакета("КонтролируемыеСделкиСпискиКодов", "ОснованияПризнанияЦеныСделкиРыночной", "Обработка.ПомощникПодготовкиУведомленияОКонтролируемыхСделках");
	
КонецФункции

Функция ПолучитьКодыМетодовЦенообразования() Экспорт
	
	Возврат ПолучитьСписокИзМакета("КонтролируемыеСделкиСпискиКодов", "МетодыЦенообразования", "Обработка.ПомощникПодготовкиУведомленияОКонтролируемыхСделках");
	
КонецФункции

Функция ПолучитьКодыКатегорийНалогоплательщика() Экспорт
	
	Возврат ПолучитьСписокИзМакета("КонтролируемыеСделкиСпискиКодов", "КодКатегорииНалогоплательщика", "Обработка.ПомощникПодготовкиУведомленияОКонтролируемыхСделках");
	
КонецФункции

Функция ПолучитьКодыФормыРеорганизации() Экспорт
	
	Возврат ПолучитьСписокИзМакета("КонтролируемыеСделкиСпискиКодов", "КодРеорганизации", "Обработка.ПомощникПодготовкиУведомленияОКонтролируемыхСделках");
	
КонецФункции

Функция ПолучитьСписокИзМакета(ИмяМакета, ИмяОбласти, ИмяИсточникаМакета = Неопределено)
	
	СписокКодов = Новый СписокЗначений();
	
	Макет = МакетПоИмениИсточникаИОбласти(ИмяМакета, ИмяОбласти, ИмяИсточникаМакета);
	Если Макет = Неопределено Тогда
		Возврат СписокКодов;
	КонецЕсли;
	
	ОбластьМакета = Макет.ПолучитьОбласть(ИмяОбласти);
	
	Для Ном = 1 По ОбластьМакета.ВысотаТаблицы Цикл
		ТекКод = СокрЛП(ОбластьМакета.Область(Ном,1, Ном, 1).Текст);
		ТекНаименование = СокрЛП(ОбластьМакета.Область(Ном, 2, Ном, 2).Текст);
		Если ЗначениеЗаполнено(ТекКод) Тогда
			ТекНаименование = "" + ТекКод + " - " + ТекНаименование;
		КонецЕсли;
		СписокКодов.Добавить(ТекКод, ТекНаименование);
	КонецЦикла;
	
	Возврат СписокКодов;
	
КонецФункции

Функция МакетПоИмениИсточникаИОбласти(ИмяМакета, ИмяОбласти, ИмяИсточникаМакета = Неопределено)
	
	Макет = Неопределено;
	
	Если ИмяИсточникаМакета = Неопределено Тогда
		Макет = ПолучитьОбщийМакет(ИмяМакета);
	Иначе
		МенеджерИсточника = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ИмяИсточникаМакета);
		Если МенеджерИсточника <> Неопределено Тогда
			Макет = МенеджерИсточника.ПолучитьМакет(ИмяМакета);
		КонецЕсли;
	КонецЕсли;
	
	Возврат Макет;
	
КонецФункции

#КонецОбласти