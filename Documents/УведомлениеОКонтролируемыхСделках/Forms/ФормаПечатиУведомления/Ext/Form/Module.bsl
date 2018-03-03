﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Не Параметры.Свойство("Уведомление") ИЛИ Не ЗначениеЗаполнено(Параметры.Уведомление.Ссылка) Тогда 
		Отказ = Истина;
		Возврат;
	Иначе
		Уведомление = Параметры.Уведомление.Ссылка;
	КонецЕсли;
	
	НомераКонтролируемыхСделокКорректны = КонтролируемыеСделки.НомераКонтролируемыхСделокУведомленияКоректны(Уведомление);
	
	ПервыйЛистДляПечати = 1;
	ПоследнийЛистДляПечати = 1;

	Переключатель = 1;
	Элементы.ПервыйЛистДляПечати.Доступность = Ложь;
	Элементы.ПоследнийЛистДляПечати.Доступность = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПодключитьОбработчикОжидания("СформироватьЛистыУведомленияСПроверкойНумерации", 0.1, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПереключательПриИзменении(Элемент)
	
	Элементы.ПервыйЛистДляПечати.Доступность = (Переключатель = 2);
	Элементы.ПоследнийЛистДляПечати.Доступность = (Переключатель = 2);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаПечатьНепосредственно(Команда)
	
	Если ПервыйЛистДляПечати > ПоследнийЛистДляПечати И 
		Переключатель = 2 Тогда 
		
		Возврат;
		
	КонецЕсли;
	
	КоличествоЛистов = ?(Переключатель = 2, ПоследнийЛистДляПечати - ПервыйЛистДляПечати + 1, ВсегоЛистов);
	ТекстВопроса = Нстр("ru = 'Распечатать уведомление о контролируемых сделках в объеме %КоличествоЛистов% страниц?'");
	ТекстВопроса = СтрЗаменить(ТекстВопроса, "%КоличествоЛистов%", КоличествоЛистов);
	Оповещение = Новый ОписаниеОповещения("ВопросРаспечататьУведомлениеОКонтролируемыхСделкахЗавершение", ЭтотОбъект);
	ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СформироватьДерево()
	
	СписокЛистов.Очистить();
	
	РезультатФоновогоЗадания = ПолучитьИзВременногоХранилища(АдресВоВременномХранилище);
	
	Листы = РезультатФоновогоЗадания.Листы;
	ВсегоЛистов = Листы.Количество();
	
	СведенияОбУведомлении.Вставить("ВсегоЛистов", ВсегоЛистов);
	
	Титульный = СписокЛистов.Добавить();
	Титульный.НазваниеГруппировки = НСтр("ru = 'Титульный лист'");
	Титульный.НачальныйНомерЛиста = 1;
	Титульный.КонечныйНомерЛиста = 1;
	НомерПервогоЛиста = 2;
	
	Если Листы.Количество()>1 
		И Листы[1].Раздел = "ТитульныйЛистФизическоеЛицо" Тогда
		ТитульныйФЛ = СписокЛистов.Добавить();
		ТитульныйФЛ.НазваниеГруппировки = НСтр("ru = 'Сведения о физлице'");
		ТитульныйФЛ.НачальныйНомерЛиста = 2;
		ТитульныйФЛ.КонечныйНомерЛиста = 2;
		НомерПервогоЛиста = 3;
	КонецЕсли;
	
	ПоследнийЛистДляПечати = ВсегоЛистов;
	
	Если ВсегоЛистов < 150 Тогда 
		КоличествоВГруппировке = 10;
	ИначеЕсли ВсегоЛистов < 250 Тогда 
		КоличествоВГруппировке = 20;
	ИначеЕсли ВсегоЛистов < 500 Тогда 
		КоличествоВГруппировке = 50;
	ИначеЕсли ВсегоЛистов < 1000 Тогда 
		КоличествоВГруппировке = 100;
	ИначеЕсли ВсегоЛистов < 5000 Тогда
		КоличествоВГруппировке = 200;
	Иначе
		КоличествоВГруппировке = 500;
	КонецЕсли;
	
	ВставленоВДерево = НомерПервогоЛиста - 1;
	
	Пока ВставленоВДерево < ВсегоЛистов Цикл 
		
		Строка = СписокЛистов.Добавить();
		Строка.НачальныйНомерЛиста = ВставленоВДерево + 1;
		
		Если ВставленоВДерево + КоличествоВГруппировке > ВсегоЛистов Тогда 
			Строка.КонечныйНомерЛиста = ВсегоЛистов;
		ИначеЕсли ВставленоВДерево < КоличествоВГруппировке Тогда 
			Строка.КонечныйНомерЛиста = КоличествоВГруппировке;
		Иначе 
			Строка.КонечныйНомерЛиста = ВставленоВДерево + КоличествоВГруппировке;
		КонецЕсли;
		ВставленоВДерево = Строка.КонечныйНомерЛиста;
		НазваниеГруппировки = НСтр("ru = 'Листы №%1-%2'");											
		Строка.НазваниеГруппировки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НазваниеГруппировки,
																					Строка.НачальныйНомерЛиста,
																					Строка.КонечныйНомерЛиста);
		
	КонецЦикла;
	
	Строка = Новый Структура("Имя,Начало,Конец", 
		Титульный.НазваниеГруппировки, Титульный.НачальныйНомерЛиста, Титульный.КонечныйНомерЛиста);
	СформироватьМакет(Строка);
	
КонецПроцедуры

&НаСервере
Функция СформироватьЛистыУведомления()
	
	СведенияОбУведомлении = Документы.УведомлениеОКонтролируемыхСделках.ПолучитьСведенияОбУведомлении(Уведомление);
	
	ДатаАктуальностиСведений = КонецГода(СведенияОбУведомлении.ОтчетныйГод);
	
	ИБФайловая = ОбщегоНазначения.ИнформационнаяБазаФайловая();
	ДлительныеОперации.ОтменитьВыполнениеЗадания(УИДЗаданиеФормированиеЛистов);
	УИДЗаданиеФормированиеЛистов = Неопределено;
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.ОтображениеЛистов, "НеИспользовать");
	
	Если ИБФайловая Тогда
		ЛистыУведомления = КонтролируемыеСделки.ПолучитьЛистыУведомления(Уведомление);
		АдресВоВременномХранилище = ПоместитьВоВременноеХранилище(ЛистыУведомления, ЭтаФорма.УникальныйИдентификатор);
		РезультатВыполнения = Новый Структура("ЗаданиеВыполнено", Истина);
	Иначе
		РезультатВыполнения = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
			УникальныйИдентификатор, 
			"КонтролируемыеСделки.ПолучитьЛистыУведомленияВФоне", 
			Уведомление, 
			НСтр("ru = 'Создание списка контролируемых сделок'"));
						
		АдресВоВременномХранилище = РезультатВыполнения.АдресХранилища;
		УИДЗаданиеФормированиеЛистов = РезультатВыполнения.ИдентификаторЗадания;
	КонецЕсли;

	Если РезультатВыполнения.ЗаданиеВыполнено Тогда
		СформироватьДерево();
	КонецЕсли;
	
	Возврат РезультатВыполнения;
	
КонецФункции

&НаСервере
Процедура СформироватьЛисты(НомерНачало, НомерКонец, ТабДок)
	
	ЛистыУведомления = ПолучитьИзВременногоХранилища(АдресВоВременномХранилище);
	
	КонтролируемыеСделки.СформироватьЛистыУведомления(ЛистыУведомления, СведенияОбУведомлении, НомерНачало, НомерКонец, ТабДок);
	
КонецПроцедуры

&НаСервере
Процедура СформироватьЛистыДляПечати(Знач НомерНачало, Знач НомерКонец, ТабДок)
	
	ТабДок.Очистить();
	ТабДок.ОбластьПечати = Неопределено;
	
	СформироватьЛисты(НомерНачало, НомерКонец, ТабДок);
	
	ТабДок.ОбластьПечати = ОтображениеДляНепосредственнойПечати.Область();
	ТабДок.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	ТабДок.АвтоМасштаб = Истина;
	ТабДок.ПолеСверху          = 5;
	ТабДок.ПолеСнизу           = 5;
	ТабДок.ИмяПараметровПечати = "Документ.УведомлениеОКонтролируемыхСделках";
	
КонецПроцедуры

&НаСервере
Процедура СформироватьМакет(Строка)
	
	ОтображениеЛистов.Очистить();
	ОтображениеЛистов.ОбластьПечати = Неопределено;
	
	СформироватьЛисты(Строка.Начало, Строка.Конец, ОтображениеЛистов);
	
	ОтображениеЛистов.ОбластьПечати = ОтображениеЛистов.Область();
	ОтображениеЛистов.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	ОтображениеЛистов.АвтоМасштаб = Истина;
	ОтображениеЛистов.ПолеСверху          = 5;
	ОтображениеЛистов.ПолеСнизу           = 5;
	ОтображениеЛистов.ИмяПараметровПечати = "Документ.УведомлениеОКонтролируемыхСделках";
	
КонецПроцедуры

//выполняет непосредственную печать на принетр уведомления
&НаКлиенте
Процедура СформироватьИНапечататьЛисты()
	
	ПервыйЛист = ?(Переключатель=1, 1, ПервыйЛистДляПечати);
	ПоследнийЛистДляПечати = ?(Переключатель=1, ВсегоЛистов, ПоследнийЛистДляПечати);
	КоличествоВКомплекте = 50;
	Пока ПервыйЛист <= ПоследнийЛистДляПечати Цикл 
		
		ПоследнийЛист = Мин(ПервыйЛист + КоличествоВКомплекте - 1, ПоследнийЛистДляПечати);
		
		СформироватьЛистыДляПечати(ПервыйЛист, ПоследнийЛист, ОтображениеДляНепосредственнойПечати);
		
		ОтображениеДляНепосредственнойПечати.Напечатать(РежимИспользованияДиалогаПечати.НеИспользовать);
		
		ПервыйЛист = ПоследнийЛист + 1;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьЛистыУведомленияВФоне()
	
	РезультатВыполнения = СформироватьЛистыУведомления();
	
	Если Не РезультатВыполнения.ЗаданиеВыполнено Тогда
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.ОтображениеЛистов, "ФормированиеОтчета");
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.ОтображениеЛистов, "НеИспользовать");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокЛистовПриАктивизацииСтроки(Элемент)
	
	Если Элемент.ТекущиеДанные = Неопределено
	 ИЛИ Элемент.ТекущаяСтрока = ТекущаяСтрокаРазделовОтчета Тогда
		Возврат;
	КонецЕсли;
	
	ТекущаяСтрокаРазделовОтчета = Элемент.ТекущаяСтрока;
	
	Строка = Новый Структура("Имя,Начало,Конец", Элемент.ТекущиеДанные.НазваниеГруппировки,
					Элемент.ТекущиеДанные.НачальныйНомерЛиста, Элемент.ТекущиеДанные.КонечныйНомерЛиста);
	СформироватьМакет(Строка);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()  
	
	Попытка
		Если ЗаданиеВыполнено(УИДЗаданиеФормированиеЛистов) Тогда 
			СформироватьДерево();
			ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.ОтображениеЛистов, "НеИспользовать");
		Иначе
			ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
			ПодключитьОбработчикОжидания(
				"Подключаемый_ПроверитьВыполнениеЗадания", 
				ПараметрыОбработчикаОжидания.ТекущийИнтервал, 
				Истина);
		КонецЕсли;
	Исключение
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.ОтображениеЛистов, "НеИспользовать");
		ВызватьИсключение;
	КонецПопытки;	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаСервереБезКонтекста
Процедура ПеренумероватьЛисты1А(Уведомление)
	
	КонтролируемыеСделки.ПеренумерацияКонтролируемыхСделокУведомления(Уведомление);
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросПеренумероватьЛистыЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Перенумеровать = (Результат = КодВозвратаДиалога.Да);
	Если Перенумеровать Тогда
		ПеренумероватьЛисты1А(Уведомление);
	КонецЕсли;
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.ОтображениеЛистов, "ФормированиеОтчета");
	ПодключитьОбработчикОжидания("СформироватьЛистыУведомленияВФоне", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросРаспечататьУведомлениеОКонтролируемыхСделкахЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		СформироватьИНапечататьЛисты();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьЛистыУведомленияСПроверкойНумерации()
	
	Если НЕ НомераКонтролируемыхСделокКорректны Тогда
		ТекстВопроса = Нстр("ru = 'Нумерация листов 1А не корректна.#РазделительСтрок#Перенумеровать листы 1А?#РазделительСтрок#(операция может занять продолжительное время)'");
		Оповещение = Новый ОписаниеОповещения("ВопросПеренумероватьЛистыЗавершение", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, СтрЗаменить(ТекстВопроса, "#РазделительСтрок#", Символы.ПС), РежимДиалогаВопрос.ДаНет);
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.ОтображениеЛистов, "ФормированиеОтчета");
		ПодключитьОбработчикОжидания("СформироватьЛистыУведомленияВФоне", 0.1, Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти