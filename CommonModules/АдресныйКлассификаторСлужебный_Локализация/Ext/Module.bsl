﻿// Подсистема "Адресный классификатор РБ"

#Область ОбщийМодуль_АдресныйКлассификаторСлужебный

Функция URIПоСтруктуре(СтруктураURI) Экспорт
	Результат = "";
	
	// Протокол
	Если Не ПустаяСтрока(СтруктураURI.Схема) Тогда
		Результат = Результат + СтруктураURI.Схема + "://";
	КонецЕсли;
	
	// Авторизация
	Если Не ПустаяСтрока(СтруктураURI.Логин) Тогда
		Результат = Результат + СтруктураURI.Логин + ":" + СтруктураURI.Пароль + "@";
	КонецЕсли;
	
	// Все остальное
	Результат = Результат + СтруктураURI.Хост;
	Если Не ПустаяСтрока(СтруктураURI.Порт) Тогда
		Результат = Результат + ":" + ?(ТипЗнч(СтруктураURI.Порт) = Тип("Число"), Формат(СтруктураURI.Порт, ""), СтруктураURI.Порт);
	КонецЕсли;
	
	Результат = Результат + "/" + СтруктураURI.ПутьНаСервере;
	
	Возврат Результат;
КонецФункции

Функция АдресИнтернетаВключаяПорт(Адрес) Экспорт
	Результат = Новый Структура;
	
	СоставАдреса = ОбщегоНазначенияКлиентСервер.СтруктураURI(Адрес);
	Если ПустаяСтрока(СоставАдреса.Порт) Тогда
		Протокол = ВРег(СоставАдреса.Схема);
		Если Протокол = "HTTP" Тогда
			СоставАдреса.Порт = 80;
		ИначеЕсли Протокол = "HTTPS" Тогда
			СоставАдреса.Порт = 443;
		КонецЕсли;
		
		Результат.Вставить("Адрес", URIПоСтруктуре(СоставАдреса));
	Иначе
		Результат.Вставить("Адрес", Адрес);
	КонецЕсли;
	
	ИмяФайла = СоставАдреса.ПутьНаСервере;
	ПозицияПараметра = СтрНайти(ИмяФайла, "?");
	Если ПозицияПараметра > 0 Тогда
		ИмяФайла = Лев(ИмяФайла, ПозицияПараметра - 1);
	КонецЕсли;
	ИмяФайла = СтрЗаменить(ИмяФайла, Символы.ПС, "");
	ИмяФайла = СтрЗаменить(ИмяФайла, "/", Символы.ПС);
	ИмяФайла = СтрЗаменить(ИмяФайла, "\", Символы.ПС);
	
	Результат.Вставить("ИмяФайла", СокрЛП(СтрПолучитьСтроку(ИмяФайла, СтрЧислоСтрок(ИмяФайла))));
	Возврат Результат;
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Функция АдресПоКлассификатору(ТекущаяСтрана) Экспорт
	Если ТекущаяСтрана = Справочники.СтраныМира.Беларусь Или ТекущаяСтрана = Справочники.СтраныМира.Россия Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
КонецФункции

Функция СтранаРоссия(ТекущаяСтрана) Экспорт
	Если ТекущаяСтрана = Справочники.СтраныМира.Беларусь Или ТекущаяСтрана = Справочники.СтраныМира.Россия Тогда
		Возврат ТекущаяСтрана;
	Иначе
		Возврат Справочники.СтраныМира.ПустаяСсылка();
	КонецЕсли;
КонецФункции

Функция СтруктураЧастейАдресаНаселенногоПункта() Экспорт
	Результат = Новый Структура;
	Результат.Вставить("Регион", ЭлементАдреснойСтруктуры(НСтр("ru = 'Страна (регион)'"), НСтр("ru = 'Страна (регион) адреса'"), "СубъектРФ", 1));
	Результат.Вставить("Район", ЭлементАдреснойСтруктуры(НСтр("ru = 'Область'"), НСтр("ru = 'Область'"), "СвРайМО/Район", 3));
	Результат.Вставить("Город", ЭлементАдреснойСтруктуры(НСтр("ru = 'Район'"), НСтр("ru = 'Район адреса'"), "Город", 4));
	Результат.Вставить("ВнутригРайон", ЭлементАдреснойСтруктуры(НСтр("ru = 'Сельский с-т'"), НСтр("ru = 'Сельский совет адреса'"), "ВнутригРайон", 5));
	Результат.Вставить("НаселенныйПункт", ЭлементАдреснойСтруктуры(НСтр("ru = 'Нас. пункт'"), НСтр("ru = 'Населенный пункт адреса'"), "НаселПункт", 6, Истина));
	Результат.Вставить("Улица", ЭлементАдреснойСтруктуры(НСтр("ru = 'Улица'"), НСтр("ru = 'Улица адреса'"), "Улица", 7));
	Результат.Вставить("ДополнительныйЭлемент", ЭлементАдреснойСтруктуры(НСтр("ru = 'ДополнительныйЭлемент'"), НСтр("ru = 'Дополнительный элемент адреса'"), "ДопАдрЭл[ТипАдрЭл='10200000']", 90));
	Результат.Вставить("ПодчиненныйЭлемент", ЭлементАдреснойСтруктуры(НСтр("ru = 'Подчиненный элемент'"), НСтр("ru = 'Подчиненный элемент адреса'"), "ДопАдрЭл[ТипАдрЭл='10400000']", 91));
	
	Возврат Результат;
КонецФункции

Функция ЭлементАдреснойСтруктуры(Заголовок, Подсказка, ПутьXPath, Уровень, Предопределенный = Ложь)
	Результат = Новый Структура("Наименование, Сокращение, Идентификатор, Представление");
	Результат.Вставить("Заголовок", Заголовок);
	Результат.Вставить("Подсказка", Подсказка);
	Результат.Вставить("ПутьXPath", ПутьXPath);
	Результат.Вставить("Предопределенный", Предопределенный);
	Результат.Вставить("Уровень", Уровень);
	
	Возврат Результат;
КонецФункции

#КонецОбласти

#Область Загрузка

Функция АдресФайлаОписанияДоступныхВерсий()
	Возврат "https://4d.by/adr/00_ver.xml";
КонецФункции

Функция АдресАрхиваНовойВерсии()
	Возврат "https://4d.by/adr/00.zip";
КонецФункции

Функция ПолучитьИнформациюОВерсииАдресныхСведенийРБ() Экспорт
	Информация = Новый Структура;
	Информация.Вставить("Версия", "Неопределено");
	Информация.Вставить("ДатаВерсии", '19000101');
	
	АдресОписания = АдресИнтернетаВключаяПорт(АдресФайлаОписанияДоступныхВерсий());
	
	ВременныйКаталог = ПолучитьИмяВременногоФайла();
	СоздатьКаталог(ВременныйКаталог);
	ВременныйКаталог = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ВременныйКаталог);
	
	ПараметрыПолучения = Новый Структура;
	ПараметрыПолучения.Вставить("ПутьДляСохранения", ВременныйКаталог + ВРег("00_ver.xml"));
	ПараметрыПолучения.Вставить("Таймаут", 180);
	
	ЗагруженныйФайл = ПолучениеФайловИзИнтернета.СкачатьФайлНаСервере(АдресОписания.Адрес, ПараметрыПолучения);
	Если ЗагруженныйФайл.Статус Тогда
		ЧтениеXML = Новый ЧтениеXML;
		ЧтениеXML.ОткрытьФайл(ЗагруженныйФайл.Путь);
		
		ОбъектXDTO = ФабрикаXDTO.ПрочитатьXML(ЧтениеXML);
		
		Информация.Вставить("Версия", ОбъектXDTO.Row.Column1);
		Информация.Вставить("ДатаВерсии", Дата(ОбъектXDTO.Row.Column2));
		
		ЧтениеXML.Закрыть();
		
		АдресныйКлассификаторСлужебный.УдалитьВременныйФайл(ВременныйКаталог);
	КонецЕсли;
	
	Возврат Информация;
КонецФункции

Функция ИнформацияОЗагруженнойВерсииАдресныхСведенийРБ() Экспорт
	Информация = Новый Структура;
	Информация.Вставить("Версия", "");
	Информация.Вставить("ДатаВерсии", '00010101');
	Информация.Вставить("ДатаЗагрузки", '00010101');
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЗагруженныеВерсииАдресныхСведений.Версия,
	|	ЗагруженныеВерсииАдресныхСведений.ДатаВерсии,
	|	ЗагруженныеВерсииАдресныхСведений.ДатаЗагрузки
	|ИЗ
	|	РегистрСведений.ЗагруженныеВерсииАдресныхСведений КАК ЗагруженныеВерсииАдресныхСведений
	|ГДЕ
	|	ЗагруженныеВерсииАдресныхСведений.КодСубъектаРФ = 0";
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	Если Выборка.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(Информация, Выборка);
	КонецЕсли;
	
	Возврат Информация;
КонецФункции

Процедура ДобавитьДоступныеВерсииАдресныхСведений(ДоступныеВерсии) Экспорт
	АктуальнаяВерсия = ПолучитьИнформациюОВерсииАдресныхСведенийРБ();
	
	Массив = Новый Массив;
	Массив.Добавить(Тип("Строка"));
	ОписаниеТиповСтрока = Новый ОписаниеТипов(Массив,, Новый КвалификаторыСтроки(36));
	
	ДоступныеВерсии.Колонки.Добавить("Версия", ОписаниеТиповСтрока);
	
	НоваяСтрока = ДоступныеВерсии.Добавить();
	НоваяСтрока.Адрес = АдресАрхиваНовойВерсии();
	НоваяСтрока.ДатаОбновления = АктуальнаяВерсия.ДатаВерсии;
	НоваяСтрока.Версия = АктуальнаяВерсия.Версия;
	НоваяСтрока.ДоступноОбновление = Истина;
	НоваяСтрока.Загружено = Истина;
	НоваяСтрока.Идентификатор = АдресныйКлассификаторКлиентСервер_Локализация.GUIDСтранаБеларусь();
	НоваяСтрока.Индекс = 0;
	НоваяСтрока.КодСубъектаРФ = 0;
	НоваяСтрока.Наименование = "Беларусь";
	НоваяСтрока.Сокращение = "Респ";
КонецПроцедуры

Функция Маска_КодАдресногоОбъектаВКоде()
	Возврат 1000000000;
КонецФункции

Функция Маска_КодРайонаВКоде()
	Возврат 1000000;
КонецФункции

Функция Маска_КодГородаВКоде()
	Возврат 1000;
КонецФункции

Процедура УдалитьПробелыВСтроке(Строка)
	ДваПробела = Символ(32) + Символ(32);
	ОдинПробел = Символ(32);
	Пока Найти(Строка, ДваПробела) > 0 Цикл
		Строка = СтрЗаменить(Строка, ДваПробела, ОдинПробел);
	КонецЦикла;
КонецПроцедуры

Функция ПолучитьСтруктуруКолонок(ТЗ)
	ОбщаяПеременная = Новый Структура;
	
	Для каждого ДанныеКолонки Из ТЗ.Колонки Цикл
		ОбщаяПеременная.Вставить(ДанныеКолонки.Имя, Неопределено);
	КонецЦикла;
	
	Возврат ОбщаяПеременная;
КонецФункции

Функция ПолучитьНаименованияКолонок(ТЗ)
	ТекстКолонки = "";
	
	Для каждого ДанныеКолонки Из ТЗ.Колонки Цикл
		ТекстКолонки = ТекстКолонки + ", " + ДанныеКолонки.Имя;
	КонецЦикла;
	
	Возврат Сред(ТекстКолонки, 3);
КонецФункции

Функция ПолучитьДанныеСОАТО(КодСОАТО, КодОбласти, ИдентификаторЭлемента = 0, КодыНаселенныхПунктов, КодКатегории, НаименованиеОбъекта = Неопределено)
	ДанныеСОАТО = Новый Структура;
	
	КодГородаВКоде = Цел(КодСОАТО / 1000) - Цел(КодСОАТО / 1000000) * 1000;
	КодНаселенногоПунктаВКоде = КодСОАТО - Цел(КодСОАТО / 1000) * 1000;
	КодРайонаВКоде = Цел((КодСОАТО - КодОбласти * Маска_КодАдресногоОбъектаВКоде()) / 1000000);
	Код = КодОбласти * Маска_КодАдресногоОбъектаВКоде() + КодРайонаВКоде * Маска_КодРайонаВКоде() + КодГородаВКоде * Маска_КодГородаВКоде() + КодНаселенногоПунктаВКоде;
	
	ДанныеСОАТО.Вставить("КодКЛАДР", Код);
	
	Если Не КодыНаселенныхПунктов.Найти(Строка(КодКатегории)) = Неопределено Тогда
		Если КодРайонаВКоде > 0 И КодГородаВКоде = 0 И КодНаселенногоПунктаВКоде = 0 Тогда
			КодНаселенногоПунктаВКоде = КодРайонаВКоде;
			КодРайонаВКоде = 0;
		КонецЕсли;
		
		Если КодРайонаВКоде > 0 И КодГородаВКоде > 0 И КодНаселенногоПунктаВКоде = 0 Тогда
			КодНаселенногоПунктаВКоде = КодГородаВКоде;
			КодГородаВКоде = 0;
		КонецЕсли;
	КонецЕсли;
	
	Код = КодОбласти * Маска_КодАдресногоОбъектаВКоде() + КодРайонаВКоде * Маска_КодРайонаВКоде() + КодГородаВКоде * Маска_КодГородаВКоде() + КодНаселенногоПунктаВКоде;
	
	ДанныеСОАТО.Вставить("КодГородаВКоде", КодГородаВКоде);
	ДанныеСОАТО.Вставить("КодНаселенногоПунктаВКоде", КодНаселенногоПунктаВКоде);
	ДанныеСОАТО.Вставить("КодРайонаВКоде", КодРайонаВКоде);
	ДанныеСОАТО.Вставить("КодУлицы", ИдентификаторЭлемента);
	ДанныеСОАТО.Вставить("Код", Код);
	
	Возврат ДанныеСОАТО;
КонецФункции

Функция СтруктураАдресногоКлассификатора()
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 0
	|	АдресныеОбъекты.Уровень,
	|	АдресныеОбъекты.КодСубъектаРФ,
	|	АдресныеОбъекты.КодОкруга,
	|	АдресныеОбъекты.КодРайона,
	|	АдресныеОбъекты.КодГорода,
	|	АдресныеОбъекты.КодВнутригородскогоРайона,
	|	АдресныеОбъекты.КодНаселенногоПункта,
	|	АдресныеОбъекты.КодУлицы,
	|	АдресныеОбъекты.КодДополнительногоЭлемента,
	|	АдресныеОбъекты.КодПодчиненногоЭлемента,
	|	АдресныеОбъекты.Идентификатор,
	|	АдресныеОбъекты.ПочтовыйИндекс,
	|	АдресныеОбъекты.Наименование,
	|	АдресныеОбъекты.Сокращение,
	|	АдресныеОбъекты.Дополнительно,
	|	АдресныеОбъекты.КодКЛАДР,
	|	АдресныеОбъекты.Актуален
	|ИЗ
	|	РегистрСведений.АдресныеОбъекты КАК АдресныеОбъекты";
	
	Возврат Запрос.Выполнить().Выгрузить();
КонецФункции

Функция ЗагрузитьАдресныйКлассификаторРБ(КаталогЗагрузки) Экспорт
	КодыНаселенныхПунктов = Новый Массив;
	КодыНаселенныхПунктов.Добавить("112");
	КодыНаселенныхПунктов.Добавить("113");
	КодыНаселенныхПунктов.Добавить("121");
	КодыНаселенныхПунктов.Добавить("122");
	КодыНаселенныхПунктов.Добавить("123");
	КодыНаселенныхПунктов.Добавить("212");
	КодыНаселенныхПунктов.Добавить("213");
	КодыНаселенныхПунктов.Добавить("221");
	КодыНаселенныхПунктов.Добавить("222");
	КодыНаселенныхПунктов.Добавить("223");
	
	МассивОшибок = Новый Массив;
	СписокДополнительныхФайлов = АдресныйКлассификаторКлиентСервер_Локализация.СписокСлужебныхФайловАдресногоКлассификатора();
	
	//------------------- "Справочник областей.xml"
	ИмяФайла = СписокДополнительныхФайлов.Получить("OBL");
	ФайлАдресногоКлассификатора = КаталогЗагрузки + ИмяФайла;
	
	ТЗСправочникОбластей = Новый ТаблицаЗначений;
	ТЗСправочникОбластей.Колонки.Добавить("КодОбласти", Новый ОписаниеТипов("Число"));
	ТЗСправочникОбластей.Колонки.Добавить("НаименованиеОбласти", Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(200, ДопустимаяДлина.Переменная)));
	ТЗСправочникОбластей.Колонки.Добавить("Актуальность", Новый ОписаниеТипов("Булево"));
	ОбщаяПеременная = ПолучитьСтруктуруКолонок(ТЗСправочникОбластей);
	
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.ОткрытьФайл(ФайлАдресногоКлассификатора);
	ОбъектXDTO = ФабрикаXDTO.ПрочитатьXML(ЧтениеXML);
	
	Для каждого СтрXDTO Из ОбъектXDTO.Row Цикл
		ДанныеСтроки = Новый Структура;
		ДанныеСтроки.Вставить("Column", "0");
		ДанныеСтроки.Вставить("Column2", "");
		ДанныеСтроки.Вставить("Column3", "1");
		ЗаполнитьЗначенияСвойств(ДанныеСтроки, СтрXDTO);
		
		ОбщаяПеременная.КодОбласти = Число(ДанныеСтроки.Column);
		ОбщаяПеременная.НаименованиеОбласти = ДанныеСтроки.Column2;
		ОбщаяПеременная.Актуальность = Число(ДанныеСтроки.Column3);
		
		Если ОбщаяПеременная.КодОбласти <= 0 Или ПустаяСтрока(ОбщаяПеременная.НаименованиеОбласти) Или ОбщаяПеременная.Актуальность = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		НоваяСтрока = ТЗСправочникОбластей.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ОбщаяПеременная);
		НоваяСтрока.Актуальность = Истина;
	КонецЦикла;
	
	ЧтениеXML.Закрыть();
	
	ТЗСправочникОбластей.Свернуть(ПолучитьНаименованияКолонок(ТЗСправочникОбластей));
	
	СчетчикЗаписей = 0;
	Для каждого Итератор Из ТЗСправочникОбластей Цикл
		Запись = РегистрыСведений.АдресныеОбъекты.СоздатьМенеджерЗаписи();
		Запись.Уровень = ?(Итератор.КодОбласти = 5, 6, 3);
		Запись.КодСубъектаРФ = 0;
		Запись.КодОкруга = 0;
		Запись.КодРайона = ?(Итератор.КодОбласти = 5, 0, Итератор.КодОбласти);
		Запись.КодГорода = 0;
		Запись.КодВнутригородскогоРайона = 0;
		Запись.КодНаселенногоПункта = 0;
		Запись.КодУлицы = 0;
		Запись.КодДополнительногоЭлемента = 0;
		Запись.КодПодчиненногоЭлемента = 0;
		Запись.Идентификатор = Новый УникальныйИдентификатор;
		Запись.ПочтовыйИндекс = 0;
		Запись.Наименование = Итератор.НаименованиеОбласти;
		Запись.Сокращение = ?(Итератор.КодОбласти = 5, "г.", "обл");
		Запись.Дополнительно = Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000");
		Запись.КодКЛАДР = Итератор.КодОбласти * Маска_КодАдресногоОбъектаВКоде();
		Запись.Актуален = Истина;
		Запись.Записать(Истина);
		
		СчетчикЗаписей = СчетчикЗаписей + 1;
	КонецЦикла;
	
	СчетчикЗаписейВсего = СчетчикЗаписей;
	//------------------- "Справочник областей.xml"
	
	Макет = РегистрыСведений.АдресныеОбъекты.ПолучитьМакет("АдресныеСокращения");
	Чтение = Новый ЧтениеXML;
	Чтение.УстановитьСтроку(Макет.ПолучитьТекст());
	ТаблицаСокращений = СериализаторXDTO.ПрочитатьXML(Чтение);
	Для каждого Стр Из ТаблицаСокращений Цикл
		Стр.Наименование = НРег(Стр.Наименование);
	КонецЦикла;
	
	КодыРегионов = Новый Массив;
	КодыРегионов.Добавить(1);
	КодыРегионов.Добавить(2);
	КодыРегионов.Добавить(3);
	КодыРегионов.Добавить(4);
	КодыРегионов.Добавить(5);
	КодыРегионов.Добавить(6);
	КодыРегионов.Добавить(7);
	
	АдресныеСведения = СтруктураАдресногоКлассификатора();
	
	//------------------- "Классификатор категорий АТЕ и ТЕ.xml"
	ИмяФайла = СписокДополнительныхФайлов.Получить("ATE_TE");
	ФайлАдресногоКлассификатора = КаталогЗагрузки + ИмяФайла;
	
	ТЗКлассификаторКатегорий = Новый ТаблицаЗначений;
	ТЗКлассификаторКатегорий.Колонки.Добавить("КодКатегории", Новый ОписаниеТипов("Число"));
	ТЗКлассификаторКатегорий.Колонки.Добавить("Наименование", Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(200, ДопустимаяДлина.Переменная)));
	ТЗКлассификаторКатегорий.Колонки.Добавить("Актуальность", Новый ОписаниеТипов("Булево"));
	ТЗКлассификаторКатегорий.Колонки.Добавить("СлеваСправа", Новый ОписаниеТипов("Число"));
	ТЗКлассификаторКатегорий.Колонки.Добавить("КраткоеНаименование", Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(200, ДопустимаяДлина.Переменная)));
	ОбщаяПеременная = ПолучитьСтруктуруКолонок(ТЗКлассификаторКатегорий);
	
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.ОткрытьФайл(ФайлАдресногоКлассификатора);
	ОбъектXDTO = ФабрикаXDTO.ПрочитатьXML(ЧтениеXML);
	
	Для каждого СтрXDTO Из ОбъектXDTO.Row Цикл
		ДанныеСтроки = Новый Структура;
		ДанныеСтроки.Вставить("Column", "0");
		ДанныеСтроки.Вставить("Column2", "");
		ДанныеСтроки.Вставить("Column3", "1");
		ДанныеСтроки.Вставить("Column4", "0");
		ДанныеСтроки.Вставить("Column5", "");
		ЗаполнитьЗначенияСвойств(ДанныеСтроки, СтрXDTO);
		
		ОбщаяПеременная.КодКатегории = Число(ДанныеСтроки.Column);
		ОбщаяПеременная.Наименование = ДанныеСтроки.Column2;
		ОбщаяПеременная.Актуальность = Число(ДанныеСтроки.Column3);
		ОбщаяПеременная.СлеваСправа = Число(ДанныеСтроки.Column4);
		ОбщаяПеременная.КраткоеНаименование = ДанныеСтроки.Column5;
		
		Если ОбщаяПеременная.КодКатегории <= 0 Или ПустаяСтрока(ОбщаяПеременная.Наименование) Или ОбщаяПеременная.Актуальность = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		НоваяСтрока = ТЗКлассификаторКатегорий.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ОбщаяПеременная);
		НоваяСтрока.Актуальность = Истина;
	КонецЦикла;
	
	ЧтениеXML.Закрыть();
	
	ТЗКлассификаторКатегорий.Свернуть(ПолучитьНаименованияКолонок(ТЗКлассификаторКатегорий));
	//------------------- "Классификатор категорий АТЕ и ТЕ.xml"
	
	//------------------- "СОАТО.xml"
	ИмяФайла = СписокДополнительныхФайлов.Получить("SOATO");
	ФайлАдресногоКлассификатора = КаталогЗагрузки + ИмяФайла;
	
	ТЗСОАТО = Новый ТаблицаЗначений;
	ТЗСОАТО.Колонки.Добавить("УИД", Новый ОписаниеТипов("Число"));
	ТЗСОАТО.Колонки.Добавить("КодСОАТО", Новый ОписаниеТипов("Число"));
	ТЗСОАТО.Колонки.Добавить("КодОбласти", Новый ОписаниеТипов("Число"));
	ТЗСОАТО.Колонки.Добавить("КодРайона", Новый ОписаниеТипов("Число"));
	ТЗСОАТО.Колонки.Добавить("НаименованиеОбъекта", Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(200, ДопустимаяДлина.Переменная)));
	ТЗСОАТО.Колонки.Добавить("КодКатегории", Новый ОписаниеТипов("Число"));
	ТЗСОАТО.Колонки.Добавить("УИДАдминистративногоЦентра", Новый ОписаниеТипов("Число"));
	ТЗСОАТО.Колонки.Добавить("Актуальность", Новый ОписаниеТипов("Булево"));
	ТЗСОАТО.Колонки.Добавить("ДатаВнесенияЗаписи", Новый ОписаниеТипов("Дата"));
	ТЗСОАТО.Колонки.Добавить("ДатаАннулированияЗаписи", Новый ОписаниеТипов("Дата"));
	ОбщаяПеременная = ПолучитьСтруктуруКолонок(ТЗСОАТО);
	
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.ОткрытьФайл(ФайлАдресногоКлассификатора);
	ОбъектXDTO = ФабрикаXDTO.ПрочитатьXML(ЧтениеXML);
	
	Для каждого СтрXDTO Из ОбъектXDTO.Row Цикл
		ДанныеСтроки = Новый Структура;
		ДанныеСтроки.Вставить("Column", "0");
		ДанныеСтроки.Вставить("Column2", "0");
		ДанныеСтроки.Вставить("Column3", "0");
		ДанныеСтроки.Вставить("Column4", "0");
		ДанныеСтроки.Вставить("Column5", "");
		ДанныеСтроки.Вставить("Column6", "0");
		ДанныеСтроки.Вставить("Column7", "0");
		ДанныеСтроки.Вставить("Column8", "1");
		ДанныеСтроки.Вставить("Column9", '00010101');
		ДанныеСтроки.Вставить("Column10", '00010101');
		ЗаполнитьЗначенияСвойств(ДанныеСтроки, СтрXDTO);
		
		ОбщаяПеременная.УИД = Число(ДанныеСтроки.Column);
		ОбщаяПеременная.КодСОАТО = Число(ДанныеСтроки.Column2);
		ОбщаяПеременная.КодОбласти = Число(ДанныеСтроки.Column3);
		ОбщаяПеременная.КодРайона = Число(ДанныеСтроки.Column4);
		ОбщаяПеременная.НаименованиеОбъекта = ДанныеСтроки.Column5;
		ОбщаяПеременная.КодКатегории = Число(ДанныеСтроки.Column6);
		ОбщаяПеременная.УИДАдминистративногоЦентра = Число(ДанныеСтроки.Column7);
		ОбщаяПеременная.Актуальность = Число(ДанныеСтроки.Column8);
		ОбщаяПеременная.ДатаВнесенияЗаписи = Дата(ДанныеСтроки.Column9);
		ОбщаяПеременная.ДатаАннулированияЗаписи = Дата(ДанныеСтроки.Column10);
		
		Если КодыРегионов.Найти(ОбщаяПеременная.КодОбласти) = Неопределено Или ОбщаяПеременная.КодСОАТО <= 0 Или ПустаяСтрока(ОбщаяПеременная.НаименованиеОбъекта) Тогда
			Продолжить;
		КонецЕсли;
		
		НоваяСтрока = ТЗСОАТО.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ОбщаяПеременная);
		НоваяСтрока.Актуальность = Истина;
	КонецЦикла;
	
	ЧтениеXML.Закрыть();
	
	ТЗСОАТО.Свернуть(ПолучитьНаименованияКолонок(ТЗСОАТО));
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТЗКлассификаторКатегорий", ТЗКлассификаторКатегорий);
	Запрос.УстановитьПараметр("ТЗСОАТО", ТЗСОАТО);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТЗКлассификаторКатегорий.КодКатегории,
	|	ТЗКлассификаторКатегорий.Наименование,
	|	ТЗКлассификаторКатегорий.КраткоеНаименование
	|ПОМЕСТИТЬ ВТКлассификаторКатегорий
	|ИЗ
	|	&ТЗКлассификаторКатегорий КАК ТЗКлассификаторКатегорий
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТЗСОАТО.КодСОАТО,
	|	ТЗСОАТО.КодОбласти,
	|	ТЗСОАТО.НаименованиеОбъекта,
	|	ТЗСОАТО.КодКатегории
	|ПОМЕСТИТЬ ВТСОАТО
	|ИЗ
	|	&ТЗСОАТО КАК ТЗСОАТО
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВТСОАТО.КодСОАТО,
	|	ВТСОАТО.КодОбласти,
	|	ВТСОАТО.НаименованиеОбъекта КАК НаименованиеОбъекта,
	|	ВТСОАТО.КодКатегории,
	|	ВТКлассификаторКатегорий.Наименование КАК НаименованиеКатегории,
	|	ВТКлассификаторКатегорий.КраткоеНаименование КАК КраткоеНаименованиеКатегории
	|ИЗ
	|	ВТСОАТО КАК ВТСОАТО
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТКлассификаторКатегорий КАК ВТКлассификаторКатегорий
	|		ПО ВТСОАТО.КодКатегории = ВТКлассификаторКатегорий.КодКатегории";
	Результат = Запрос.Выполнить();
	ОбщаяПеременная = ПолучитьСтруктуруКолонок(АдресныеСведения);
	
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		ДанныеСОАТО = ПолучитьДанныеСОАТО(Выборка.КодСОАТО, Выборка.КодОбласти,, КодыНаселенныхПунктов, Выборка.КодКатегории, Выборка.НаименованиеОбъекта);
		
		ОбщаяПеременная.КодСубъектаРФ = 0;
		ОбщаяПеременная.КодОкруга = 0;
		ОбщаяПеременная.КодРайона = Выборка.КодОбласти;
		ОбщаяПеременная.КодГорода = ДанныеСОАТО.КодРайонаВКоде;
		ОбщаяПеременная.КодВнутригородскогоРайона = ДанныеСОАТО.КодГородаВКоде;
		ОбщаяПеременная.КодНаселенногоПункта = ДанныеСОАТО.КодНаселенногоПунктаВКоде;
		ОбщаяПеременная.КодУлицы = 0;
		ОбщаяПеременная.КодДополнительногоЭлемента = 0;
		ОбщаяПеременная.КодПодчиненногоЭлемента = 0;
		ОбщаяПеременная.Идентификатор = Новый УникальныйИдентификатор;
		ОбщаяПеременная.ПочтовыйИндекс = "";
		ОбщаяПеременная.Наименование = Выборка.НаименованиеОбъекта;
		
		ДанныеОтбора = Новый Структура;
		ДанныеОтбора.Вставить("Наименование", НРег(Выборка.КраткоеНаименованиеКатегории));
		ЗначениеОтбора = ТаблицаСокращений.Скопировать(ДанныеОтбора);
		Если ЗначениеОтбора.Количество() > 0 Тогда
			ОбщаяПеременная.Сокращение = ЗначениеОтбора[0].Сокращение;
		Иначе
			ОбщаяПеременная.Сокращение = Выборка.КраткоеНаименованиеКатегории;
		КонецЕсли;
		
		ОбщаяПеременная.Дополнительно = Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000");
		ОбщаяПеременная.КодКЛАДР = ДанныеСОАТО.КодКЛАДР;
		ОбщаяПеременная.Актуален = Истина;
		ОбщаяПеременная.Вставить("Код", ДанныеСОАТО.Код);
		
		Если ДанныеСОАТО.КодРайонаВКоде > 0 И ДанныеСОАТО.КодНаселенногоПунктаВКоде = 0 И ДанныеСОАТО.КодГородаВКоде = 0 Тогда
			ОбщаяПеременная.Уровень = 4;
		ИначеЕсли ДанныеСОАТО.КодРайонаВКоде > 0 И ДанныеСОАТО.КодНаселенногоПунктаВКоде = 0 Тогда
			ОбщаяПеременная.Уровень = 5;
		Иначе
			ОбщаяПеременная.Уровень = 6;
		КонецЕсли;
		
		ДобавитьЗаписьТЗ(АдресныеСведения, ОбщаяПеременная);
	КонецЦикла;
	//------------------- "СОАТО.xml"
	
	//------------------- "Справочник улиц.xml"
	ИмяФайла = СписокДополнительныхФайлов.Получить("UL");
	ФайлАдресногоКлассификатора = КаталогЗагрузки + ИмяФайла;
	
	ТЗСправочникУлиц = Новый ТаблицаЗначений;
	ТЗСправочникУлиц.Колонки.Добавить("КодСОАТО", Новый ОписаниеТипов("Число"));
	ТЗСправочникУлиц.Колонки.Добавить("ИдентификаторАТЕ", Новый ОписаниеТипов("Число"));
	ТЗСправочникУлиц.Колонки.Добавить("Область", Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(200, ДопустимаяДлина.Переменная)));
	ТЗСправочникУлиц.Колонки.Добавить("Район", Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(200, ДопустимаяДлина.Переменная)));
	ТЗСправочникУлиц.Колонки.Добавить("Сельсовет", Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(200, ДопустимаяДлина.Переменная)));
	ТЗСправочникУлиц.Колонки.Добавить("НаселенныйПункт", Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(200, ДопустимаяДлина.Переменная)));
	ТЗСправочникУлиц.Колонки.Добавить("ИдентификаторВида", Новый ОписаниеТипов("Число"));
	ТЗСправочникУлиц.Колонки.Добавить("НаименованиеВида", Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(200, ДопустимаяДлина.Переменная)));
	ТЗСправочникУлиц.Колонки.Добавить("ИдентификаторЭлемента", Новый ОписаниеТипов("Число"));
	ТЗСправочникУлиц.Колонки.Добавить("НаименованиеПоРусски", Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(200, ДопустимаяДлина.Переменная)));
	ТЗСправочникУлиц.Колонки.Добавить("НаименованиеПоБелорусски", Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(200, ДопустимаяДлина.Переменная)));
	ТЗСправочникУлиц.Колонки.Добавить("ДатаРегистрации", Новый ОписаниеТипов("Дата"));
	ТЗСправочникУлиц.Колонки.Добавить("ДатаАннулирования", Новый ОписаниеТипов("Дата"));
	ОбщаяПеременная = ПолучитьСтруктуруКолонок(ТЗСправочникУлиц);
	
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.ОткрытьФайл(ФайлАдресногоКлассификатора);
	ОбъектXDTO = ФабрикаXDTO.ПрочитатьXML(ЧтениеXML);
	
	Для каждого СтрXDTO Из ОбъектXDTO.Row Цикл
		ДанныеСтроки = Новый Структура;
		ДанныеСтроки.Вставить("Column", "0");
		ДанныеСтроки.Вставить("Column2", "0");
		ДанныеСтроки.Вставить("Column3", "");
		ДанныеСтроки.Вставить("Column4", "");
		ДанныеСтроки.Вставить("Column5", "");
		ДанныеСтроки.Вставить("Column6", "");
		ДанныеСтроки.Вставить("Column7", "0");
		ДанныеСтроки.Вставить("Column8", "");
		ДанныеСтроки.Вставить("Column9", "0");
		ДанныеСтроки.Вставить("Column10", "");
		ДанныеСтроки.Вставить("Column11", "");
		ДанныеСтроки.Вставить("Column12", '00010101');
		ДанныеСтроки.Вставить("Column13", '00010101');
		ЗаполнитьЗначенияСвойств(ДанныеСтроки, СтрXDTO);
		
		ОбщаяПеременная.КодСОАТО = Число(ДанныеСтроки.Column);
		ОбщаяПеременная.ИдентификаторАТЕ = Число(ДанныеСтроки.Column2);
		ОбщаяПеременная.Область = ДанныеСтроки.Column3;
		ОбщаяПеременная.Район = ДанныеСтроки.Column4;
		ОбщаяПеременная.Сельсовет = ДанныеСтроки.Column5;
		ОбщаяПеременная.НаселенныйПункт = ДанныеСтроки.Column6;
		ОбщаяПеременная.ИдентификаторВида = Число(ДанныеСтроки.Column7);
		ОбщаяПеременная.НаименованиеВида = ДанныеСтроки.Column8;
		ОбщаяПеременная.ИдентификаторЭлемента = Число(ДанныеСтроки.Column9);
		ОбщаяПеременная.НаименованиеПоРусски = ДанныеСтроки.Column10;
		ОбщаяПеременная.НаименованиеПоБелорусски = ДанныеСтроки.Column11;
		ОбщаяПеременная.ДатаРегистрации = Дата(ДанныеСтроки.Column12);
		ОбщаяПеременная.ДатаАннулирования = Дата(ДанныеСтроки.Column13);
		
		КодОбласти = Цел(ОбщаяПеременная.КодСОАТО / Маска_КодАдресногоОбъектаВКоде());
		Если КодыРегионов.Найти(КодОбласти) = Неопределено Или ОбщаяПеременная.КодСОАТО <= 0 Тогда
			Продолжить;
		КонецЕсли;
		
		НоваяСтрока = ТЗСправочникУлиц.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ОбщаяПеременная);
	КонецЦикла;
	
	ЧтениеXML.Закрыть();
	
	Для каждого Стр Из ТЗСправочникУлиц Цикл
		Стр.НаименованиеПоРусски = СтрЗаменить(Стр.НаименованиеПоРусски, "ё", "е");
	КонецЦикла;
	
	ТЗСправочникУлиц.Свернуть(ПолучитьНаименованияКолонок(ТЗСправочникУлиц));
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТЗСОАТО", ТЗСОАТО);
	Запрос.УстановитьПараметр("ТЗСправочникУлиц", ТЗСправочникУлиц);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТЗСОАТО.КодСОАТО,
	|	ТЗСОАТО.КодОбласти,
	|	ТЗСОАТО.КодКатегории
	|ПОМЕСТИТЬ ВТСОАТО
	|ИЗ
	|	&ТЗСОАТО КАК ТЗСОАТО
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТЗСправочникУлиц.КодСОАТО,
	|	ТЗСправочникУлиц.НаименованиеВида,
	|	ТЗСправочникУлиц.ИдентификаторЭлемента,
	|	ТЗСправочникУлиц.НаименованиеПоРусски
	|ПОМЕСТИТЬ ВТСправочникУлиц
	|ИЗ
	|	&ТЗСправочникУлиц КАК ТЗСправочникУлиц
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВТСОАТО.КодСОАТО,
	|	ВТСОАТО.КодОбласти,
	|	ВТСОАТО.КодКатегории
	|ПОМЕСТИТЬ ВТСОАТОКоды
	|ИЗ
	|	ВТСОАТО КАК ВТСОАТО
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВТСправочникУлиц.КодСОАТО,
	|	ВТСправочникУлиц.НаименованиеВида,
	|	ВТСправочникУлиц.ИдентификаторЭлемента,
	|	ВТСправочникУлиц.НаименованиеПоРусски,
	|	ВТСОАТО.КодОбласти,
	|	ВТСОАТО.КодКатегории
	|ИЗ
	|	ВТСправочникУлиц КАК ВТСправочникУлиц
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТСОАТОКоды КАК ВТСОАТО
	|		ПО ВТСправочникУлиц.КодСОАТО = ВТСОАТО.КодСОАТО";
	Результат = Запрос.Выполнить();
	ОбщаяПеременная = ПолучитьСтруктуруКолонок(АдресныеСведения);
	
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		ДанныеСОАТО = ПолучитьДанныеСОАТО(Выборка.КодСОАТО, Выборка.КодОбласти, Выборка.ИдентификаторЭлемента, КодыНаселенныхПунктов, Выборка.КодКатегории, Выборка.НаименованиеПоРусски);
		
		ОбщаяПеременная.КодСубъектаРФ = 0;
		ОбщаяПеременная.КодОкруга = 0;
		ОбщаяПеременная.КодРайона = ?(Выборка.КодОбласти = 5, 0, Выборка.КодОбласти);
		ОбщаяПеременная.КодГорода = ДанныеСОАТО.КодРайонаВКоде;
		ОбщаяПеременная.КодВнутригородскогоРайона = ДанныеСОАТО.КодГородаВКоде;
		ОбщаяПеременная.КодНаселенногоПункта = ДанныеСОАТО.КодНаселенногоПунктаВКоде;
		ОбщаяПеременная.КодУлицы = Выборка.ИдентификаторЭлемента;
		ОбщаяПеременная.КодДополнительногоЭлемента = 0;
		ОбщаяПеременная.КодПодчиненногоЭлемента = 0;
		ОбщаяПеременная.Идентификатор = Новый УникальныйИдентификатор;
		ОбщаяПеременная.ПочтовыйИндекс = "";
		ОбщаяПеременная.Наименование = Выборка.НаименованиеПоРусски;
		
		ДанныеОтбора = Новый Структура;
		ДанныеОтбора.Вставить("Наименование", НРег(Выборка.НаименованиеВида));
		ЗначениеОтбора = ТаблицаСокращений.Скопировать(ДанныеОтбора);
		Если ЗначениеОтбора.Количество() > 0 Тогда
			ОбщаяПеременная.Сокращение = ЗначениеОтбора[0].Сокращение;
		Иначе
			ОбщаяПеременная.Сокращение = Выборка.НаименованиеВида;
		КонецЕсли;
		
		ОбщаяПеременная.Дополнительно = Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000");
		ОбщаяПеременная.КодКЛАДР = ДанныеСОАТО.КодКЛАДР;
		ОбщаяПеременная.Актуален = Истина;
		ОбщаяПеременная.Вставить("Код", ДанныеСОАТО.Код);
		ОбщаяПеременная.Уровень = 7;
		
		ДобавитьЗаписьТЗ(АдресныеСведения, ОбщаяПеременная);
	КонецЦикла;
	//------------------- "Справочник улиц.xml"
	
	ЗаписатьАдресныеСведенияВРегистр(АдресныеСведения, МассивОшибок, СчетчикЗаписейВсего);
	
	ЗаписьЖурналаРегистрации("РегламентныеЗадания.ОбновлениеАдресногоКлассификатора_Локализация", УровеньЖурналаРегистрации.Информация, Метаданные.РегистрыСведений.АдресныеОбъекты,,
		"Загрузка адресного классификатора Республики Беларусь успешно завершена!" + Символы.ПС + "Добавлено записей: " + СчетчикЗаписейВсего);
	
	МассивОшибок.Добавить("Загрузка успешно завершена!");
	
	ПараметрыОшибок = Новый Структура;
	ПараметрыОшибок.Вставить("МассивОшибок", МассивОшибок);
	
	Возврат ПараметрыОшибок;
КонецФункции

Процедура ДобавитьЗаписьТЗ(АдресныеСведения, ОбщаяПеременная)
	ЗаписьАдреса = АдресныеСведения.Добавить();
	ЗаполнитьЗначенияСвойств(ЗаписьАдреса, ОбщаяПеременная);
КонецПроцедуры

Процедура ЗаписатьАдресныеСведенияВРегистр(АдресныеСведения, МассивОшибок, СчетчикЗаписейВсего)
	ИспользованныеКоды = Новый ТаблицаЗначений;
	ИспользованныеКоды.Колонки.Добавить("КодПроверки");
	ИспользованныеКоды.Колонки.Добавить("Улица");
	ИспользованныеКоды.Колонки.Добавить("Сокращение");
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	АдресныйКлассификатор.КодКЛАДР * 10000 + АдресныйКлассификатор.КодУлицы КАК Код,
	|	АдресныйКлассификатор.Наименование КАК Наименование,
	|	АдресныйКлассификатор.КодУлицы КАК КодУлицы,
	|	АдресныйКлассификатор.Сокращение КАК Сокращение
	|ИЗ
	|	РегистрСведений.АдресныеОбъекты КАК АдресныйКлассификатор
	|ГДЕ
	|	АдресныйКлассификатор.КодСубъектаРФ = 0";
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		НоваяСтр = ИспользованныеКоды.Добавить();
		НоваяСтр.КодПроверки = Выборка.Код;
		
		Если Выборка.КодУлицы > 0 Тогда
			НоваяСтр.Улица = Выборка.Наименование;
			НоваяСтр.Сокращение = Выборка.Сокращение;
		Иначе
			НоваяСтр.Улица = "";
			НоваяСтр.Сокращение = "";
		КонецЕсли;
	КонецЦикла;
	
	СчетчикЗаписей = 0;
	
	Для каждого СтрАдрес Из АдресныеСведения Цикл
		ЗагружаемыйКод = СтрАдрес.КодКЛАДР * 10000 + СтрАдрес.КодУлицы;
		
		ПараметрыОтбора = Новый Структура;
		ПараметрыОтбора.Вставить("КодПроверки", ЗагружаемыйКод);
		
		Если СтрАдрес.КодУлицы > 0 Тогда
			ПараметрыОтбора.Вставить("Улица", СтрАдрес.Наименование);
			ПараметрыОтбора.Вставить("Сокращение", СтрАдрес.Сокращение);
		Иначе
			ПараметрыОтбора.Вставить("Улица", "");
			ПараметрыОтбора.Вставить("Сокращение", "");
		КонецЕсли;
		
		Если ИспользованныеКоды.НайтиСтроки(ПараметрыОтбора).Количество() = 0 Тогда
			НоваяСтр = ИспользованныеКоды.Добавить();
			НоваяСтр.КодПроверки = ЗагружаемыйКод;
			
			Если СтрАдрес.КодУлицы > 0 Тогда
				НоваяСтр.Улица = СтрАдрес.Наименование;
				НоваяСтр.Сокращение = СтрАдрес.Сокращение;
			Иначе
				НоваяСтр.Улица = "";
				НоваяСтр.Сокращение = "";
			КонецЕсли;
		Иначе
			Продолжить;
		КонецЕсли;
		
		Если СчетчикЗаписей = 0 Тогда
			НаборАдресныхСведений = РегистрыСведений.АдресныеОбъекты.СоздатьНаборЗаписей();
		КонецЕсли;
		
		ЗаписьАдреса = НаборАдресныхСведений.Добавить();
		ЗаполнитьЗначенияСвойств(ЗаписьАдреса, СтрАдрес);
		
		Если СчетчикЗаписей > 10000 Тогда
			НаборАдресныхСведений.Записать(Ложь);
			СчетчикЗаписей = 0;
		Иначе
			СчетчикЗаписей = СчетчикЗаписей + 1;
		КонецЕсли;
		
		СчетчикЗаписейВсего = СчетчикЗаписейВсего + 1;
	КонецЦикла;
	
	Если СчетчикЗаписей > 0 Тогда
		НаборАдресныхСведений.Записать(Ложь);
	КонецЕсли;
	
	МассивОшибок.Добавить("Добавлено записей: " + СчетчикЗаписейВсего);
КонецПроцедуры

#КонецОбласти