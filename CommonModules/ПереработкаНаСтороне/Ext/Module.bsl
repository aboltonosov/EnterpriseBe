﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Переработка на стороне".
// 
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

Функция ПредставлениеГруппыЗатрат(Знач ПараметрыГруппыЗатрат, Знач ГруппировкаЗатрат, Знач Продукция, Знач ИмяПоляГруппаЗатрат) Экспорт
	
	ПредставлениеГруппы = "";
	
	Если ГруппировкаЗатрат = Перечисления.ГруппировкиЗатратВЗаказеПереработчику.ПоПродукции
		ИЛИ ГруппировкаЗатрат = Перечисления.ГруппировкиЗатратВЗаказеПереработчику.ПоСпецификациям Тогда
		
		СтруктураПоиска = Новый Структура(ИмяПоляГруппаЗатрат, ПараметрыГруппыЗатрат[ИмяПоляГруппаЗатрат]);
		СписокСтрок = Продукция.НайтиСтроки(СтруктураПоиска);
		Если СписокСтрок.Количество() = 0 Тогда
			Возврат "";
		КонецЕсли;
		СтрокаПродукция = СписокСтрок[0];
		Если ГруппировкаЗатрат = Перечисления.ГруппировкиЗатратВЗаказеПереработчику.ПоПродукции Тогда
			ПредставлениеГруппы = НоменклатураКлиентСервер.ПредставлениеНоменклатуры(
										Строка(СтрокаПродукция.Номенклатура),
										Строка(СтрокаПродукция.Характеристика));
			
		Иначе
			ПредставлениеГруппы = Строка(СтрокаПродукция.Спецификация);
		КонецЕсли;
		
		//++ НЕ УТКА	
	Иначе
		
		Если ЗначениеЗаполнено(ПараметрыГруппыЗатрат.Распоряжение) Тогда
			Если ГруппировкаЗатрат = Перечисления.ГруппировкиЗатратВЗаказеПереработчику.ПоЗаказамНаПроизводство Тогда
				ШаблонТекста = НСтр("ru = 'Заказ № %1 от %2 (%3)'");
			Иначе
				ШаблонТекста = НСтр("ru = 'Этап № %1 от %2 (%3)'");
			КонецЕсли; 
			РеквизитыРаспоряжения = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ПараметрыГруппыЗатрат.Распоряжение, "Номер,Дата");
			ПредставлениеГруппы = СтрШаблон(ШаблонТекста,
										ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(РеквизитыРаспоряжения.Номер, Ложь, Истина),
										Формат(РеквизитыРаспоряжения.Дата, "ДЛФ=D"),
										ПараметрыГруппыЗатрат.Спецификация);
		КонецЕсли; 
		
		//-- НЕ УТКА
	КонецЕсли;
	
	Возврат ПредставлениеГруппы;

КонецФункции 

// Проверяет возможность закрытия заказа
//
// Параметры:
//  Объект	 - ДокументОбъект.ЗаказПереработчику - контролируемый документ.
//  Отказ	 - Булево							 - параметр Отказ.
//
Процедура ВыполнитьКонтрольЗаказаПослеПроведения(Объект, Отказ) Экспорт
	
	Если Объект.Статус <> Перечисления.СтатусыЗаказовПереработчикам.Закрыт Тогда
		Возврат;
	КонецЕсли;
	
	ТекстЗапроса = 
		"ВЫБРАТЬ
		|	ЗаказыКлиентовОстатки.ЗаказКлиента КАК ЗаказКлиента
		|ИЗ
		|	РегистрНакопления.ЗаказыКлиентов.Остатки(, ЗаказКлиента = &Ссылка) КАК ЗаказыКлиентовОстатки
		|ГДЕ
		|	&КонтролироватьПолнуюОтработку
		|	И (ЗаказыКлиентовОстатки.ЗаказаноОстаток > 0
		|			ИЛИ ЗаказыКлиентовОстатки.КОформлениюОстаток > 0)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ТоварыКОтгрузкеОстатки.ДокументОтгрузки
		|ИЗ
		|	РегистрНакопления.ТоварыКОтгрузке.Остатки(, ДокументОтгрузки = &Ссылка) КАК ТоварыКОтгрузкеОстатки
		|ГДЕ
		|	&КонтролироватьПолнуюОтработку
		|	И ТоварыКОтгрузкеОстатки.КОтгрузкеОстаток + ТоварыКОтгрузкеОстатки.СобраноОстаток > 0
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Расчеты.Валюта КАК Валюта,
		|	-Расчеты.КОплатеОстаток КАК КОплатеОстаток
		|ИЗ
		|	РегистрНакопления.РасчетыСПоставщиками.Остатки(, ЗаказПоставщику = &Ссылка) КАК Расчеты
		|ГДЕ
		|	&КонтролироватьРасчеты
		|	И Расчеты.КОплатеОстаток < 0
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ЗаказыПоставщикамОстатки.ЗаказПоставщику КАК ЗаказПоставщику
		|ИЗ
		|	РегистрНакопления.ЗаказыПоставщикам.Остатки(, ЗаказПоставщику = &Ссылка) КАК ЗаказыПоставщикамОстатки
		|ГДЕ
		|	&КонтролироватьПолнуюОтработку
		|	И (ЗаказыПоставщикамОстатки.ЗаказаноОстаток > 0
		|			ИЛИ ЗаказыПоставщикамОстатки.КОформлениюОстаток > 0)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ТоварыКПоступлениюОстатки.ДокументПоступления
		|ИЗ
		|	РегистрНакопления.ТоварыКПоступлению.Остатки(, ДокументПоступления = &Ссылка) КАК ТоварыКПоступлениюОстатки
		|ГДЕ
		|	&КонтролироватьПолнуюОтработку
		|	И ТоварыКПоступлениюОстатки.КПоступлениюОстаток + ТоварыКПоступлениюОстатки.ПринимаетсяОстаток > 0
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	УслугиПереработчика.СуммаКонечныйОстаток КАК Сумма
		|ИЗ
		|	РегистрНакопления.УслугиПереработчиковКОформлению.ОстаткиИОбороты(, , , , ЗаказПереработчику = &Ссылка) КАК УслугиПереработчика
		|ГДЕ
		|	ЕСТЬNULL(УслугиПереработчика.СуммаКонечныйОстаток, 0) > 0
		|	И &КонтролироватьПолнуюОтработку";
		
	КонтролироватьПолнуюОтработку = ПолучитьФункциональнуюОпцию("НеЗакрыватьЗаказыПереработчикамБезПолнойОтработки");
	КонтролироватьРасчеты = ПолучитьФункциональнуюОпцию("НеЗакрыватьЗаказыПереработчикамБезПолнойОплаты")
								И Объект.ПорядокРасчетов <> Перечисления.ПорядокРасчетов.ПоДоговорамКонтрагентов;
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	Запрос.УстановитьПараметр("КонтролироватьПолнуюОтработку", КонтролироватьПолнуюОтработку);
	Запрос.УстановитьПараметр("КонтролироватьРасчеты", КонтролироватьРасчеты);
	Результат = Запрос.ВыполнитьПакет();
	
	ВыборкаОтгрузка    = Результат[0].Выбрать();
	ВыборкаРасчеты     = Результат[1].Выбрать();
	ВыборкаПоступление = Результат[2].Выбрать();
	ВыборкаОтчеты      = Результат[3].Выбрать();
	
	Если ВыборкаОтгрузка.Следующий() Тогда 
		ТекстОшибки = НСтр("ru='Сырье и материалы по заказу ""%1"" отгружены не полностью.
							|Закрытие заказа возможно только с полностью отгруженными/отмененными строками'");
							
		ТекстОшибки = СтрШаблон(ТекстОшибки, Объект.Ссылка);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, Объект.Ссылка,,, Отказ);
	КонецЕсли;
	
	Если ВыборкаПоступление.Следующий() Тогда 
		ТекстОшибки = НСтр("ru = 'Продукция по заказу ""%1"" поступила не полностью.
                            |Закрытие заказа возможно только с полностью поступившими/отмененными строками'");
		
		ТекстОшибки = СтрШаблон(ТекстОшибки, Объект.Ссылка);
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, Объект.Ссылка,,, Отказ);
	КонецЕсли;
	
	Если ВыборкаРасчеты.Следующий() Тогда 
		ТекстОшибки = НСтр("ru='Расчеты по заказу ""%1"" не завершены.
		|Для закрытия заказа требуется оплата %2 %3
		|Закрытие заказа возможно только с полностью оплаченными/отмененными строками'");
		
		ТекстОшибки = СтрШаблон(ТекстОшибки, 
							Объект.Ссылка, 
							Строка(ВыборкаРасчеты.КОплатеОстаток), 
							Строка(ВыборкаРасчеты.Валюта));
							
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, Объект.Ссылка,,, Отказ);
	КонецЕсли;
	
	Если ВыборкаОтчеты.Следующий() Тогда 
		ТекстОшибки = НСтр("ru='Не все отчеты переработчику сформированы.
		|Для закрытия заказа требуется оформление отчетов на %1 %2.
		|Закрытие заказа возможно только с откорректированной стоимостью услуг'");
		
		ТекстОшибки = СтрШаблон(ТекстОшибки, Строка(ВыборкаОтчеты.Сумма), Строка(Объект.Валюта));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, Объект.Ссылка,,, Отказ);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
